from __future__ import (division, print_function, absolute_import)


from argparse import ArgumentParser
import os
import re
from pkg_resources import parse_version
import requests

import ruamel_yaml as yaml

from conda import exports as conda_exports

from six.moves import xmlrpc_client as xmlrpclib

from jinja2 import Environment, FileSystemLoader, Template
from jinja2.exceptions import TemplateNotFound

PYPI_XMLRPC = 'https://pypi.python.org/pypi'
TEMPLATE_FOLDER = 'recipe-templates'
RECIPE_FOLDER = 'recipes'
ALL_PLATFORMS = ['osx-64', 'linux-64', 'linux-32', 'win-32', 'win-64']

CONDA_FORGE_RECIPE_BASE = 'https://raw.githubusercontent.com/conda-forge/{}-feedstock/master/recipe/meta.yaml'

def get_pypi_info(name):
    url = "https://pypi.python.org/pypi/{}/json".format(name)
    return sorted(requests.get(url).json()["releases"], key=parse_version, reverse=True)


class Package(object):
    """
    A package to be built for conda.

    Parameters
    ----------

    pypi_name : str
        Name of the package on PyPI. Note that PyPI is not case sensitive.

    version: str, optional
        Version number of the package. ``None``, the default, implies the most
        recent version visible on PyPI should be used.
    """

    # The class should only need one client for communicating with PyPI
    client = xmlrpclib.ServerProxy(PYPI_XMLRPC)

    def __init__(self, conda_name, version=None,
                 pypi_name=None,
                 numpy_compiled_extensions=False,
                 setup_options=None,
                 python_requirements=None,
                 numpy_requirements=None,
                 excluded_platforms=None,
                 include_extras=False):
        self._conda_name = conda_name
        self._pypi_name = pypi_name
        if version is not None:
            self.required_version = version
        else:
            self._required_version = None
        self._build = False
        self._url = None
        self._md5 = None
        self._version = None
        self._build_platforms = None
        self._extra_meta = None
        self._build_pythons = None
        self._pypi_name = pypi_name
        self._numpy_compiled_extensions = numpy_compiled_extensions
        self._setup_options = setup_options
        self._python_requirements = python_requirements
        self._numpy_requirements = numpy_requirements
        self._excluded_platforms = excluded_platforms or []
        self._include_extras = include_extras

    @property
    def pypi_name(self):
        """
        Name of the package on PyPI; may differ from conda_name
        """
        return self._pypi_name

    @property
    def conda_name(self):
        """
        Name of the package for conda-bld, which requires lowercase
        names. This is set by the constructor.
        """
        return self._conda_name.lower()

    @property
    def required_version(self):
        """
        Version number of the package.
        """
        return self._required_version

    @required_version.setter
    def required_version(self, value):
        self._required_version = str(value).strip()

    @property
    def build(self):
        """
        bool:
            ``True`` if this package needs to be built.
        """
        return self._build

    @build.setter
    def build(self, value):
        # TODO: Make sure this is a bool
        self._build = value

    @property
    def numpy_compiled_extensions(self):
        return self._numpy_compiled_extensions

    @property
    def setup_options(self):
        return self._setup_options

    @property
    def python_requirements(self):
        return self._python_requirements

    @property
    def numpy_requirements(self):
        return self._numpy_requirements

    @property
    def include_extras(self):
        return self._include_extras

    @property
    def is_dev(self):
        return not (re.search('[a-zA-Z]', self.required_version) is None)

    @property
    def url(self):
        if not self._url:
            self._retrieve_package_metadata()

        return self._url

    @property
    def version(self):
        if not self._version:
            self._retrieve_package_metadata()

        return self._version

    @property
    def md5(self):
        if not self._md5:
            self._retrieve_package_metadata()

        return self._md5

    @property
    def filename(self):
        return self.url.split('/')[-1]

    @property
    def build_platforms(self):
        """
        Return list of platforms on which this package can be built.

        Defaults to the value of ``ALL_PLATFORMS``.

        Checks for build information by looking at recipe *templates*, which
        is probably not really the way to go...might be more generalizable if
        it looked at recipes instead.

        Also excludes any platforms indicated in requirements.yml,
        """
        # Lazy memoization...
        if self._build_platforms:
            return self._build_platforms

        platform_info = self.extra_meta

        try:
            platforms = platform_info['extra']['platforms']
        except KeyError:
            platforms = ALL_PLATFORMS

        platforms = list(set(platforms) - set(self._excluded_platforms))

        self._build_platforms = platforms
        return self._build_platforms

    @property
    def build_pythons(self):
        if self._build_pythons:
            return self._build_pythons
        try:
            pythons = self.extra_meta['extra']['pythons']
        except KeyError:
            pythons = ["27", "35"]

        # Make sure version is always a string so it can be compared
        # to CONDA_PY later.
        self._build_pythons = [str(p) for p in pythons]
        return self._build_pythons

    @property
    def extra_meta(self):
        """
        The 'extra' metadata, for now read in from meta.yaml.
        """
        if self._extra_meta is not None:
            return self._extra_meta

        try:
            meta = render_template(self, 'meta.yaml')
        except TemplateNotFound:
            # No recipe, make an empty meta for now.
            meta = ''

        platform_info = yaml.safe_load(meta) if meta else {}
        self._extra_meta = platform_info

        return self._extra_meta

    def _retrieve_package_metadata(self):
        """
        Get URL and md5 checksum from PyPI for either the specified version
        or the most recent version.
        """
        if self.required_version is None:
            version = get_pypi_info(self.pypi_name)
        else:
            version = self.required_version

        urls = self.client.release_urls(self.pypi_name, version)
        try:
            # Many packages now have wheels, need to iterate over download
            # URLs to get the source distribution.
            for a_url in urls:
                if a_url['packagetype'] == 'sdist':
                    url = a_url['url']
                    md5sum = a_url['md5_digest']
                    break
            else:
                # No source distribution, so raise an index error
                raise IndexError
        except IndexError:
            # Apparently a pypi release isn't required to have any source?
            # If it doesn't, then return None
            print('No source found for {}: {}'.format(self.pypi_name,
                  self.required_version))
            url = None
            md5sum = None
        self._url = url
        self._md5 = md5sum
        self._version = version


    @property
    def supported_platform(self):
        """
        True if the current build platform is supported by the package, False
        otherwise.
        """
        return conda_exports.subdir in self.build_platforms


def get_package_versions(requirements_path):
    """
    Read and parse list of packages.

    Parameters
    ----------

    requirements_path : str
        Path to ``requirements.yml``

    Returns
    -------

    list
        List of ``Package`` objects, one for each in the requirements file.
    """
    with open(requirements_path, 'rt') as f:
        package_list = yaml.safe_load(f)

    packages = []
    for p in package_list:
        pypi_name = p.get('pypi_name', p['name'])
        helpers = p.get('setup_options', None)
        numpy_extensions = p.get('numpy_compiled_extensions', False)
        python_requirements = p.get('python', [])
        numpy_requirements = p.get('numpy_build_restrictions', [])
        version = p.get('version', None)
        excluded_platforms = p.get('excluded_platforms', [])
        include_extras = p.get('include_extras', False)

        # find the versions
        version = p.get('version', None)
        if version is None:
            releases = get_pypi_info(pypi_name)
            versions = [releases[0]] # build the latest from pypi
            past_versions = p.get('past_versions', [])
            for past_ver in past_versions:
                if past_ver not in versions:
                    versions.append(past_ver)
        else:
            versions = [version]


        # TODO: Get supported platforms from requirements,
        #       not from recipe template.
        for version in versions:
            packages.append(Package(p['name'],
                                pypi_name=pypi_name,
                                version=version,
                                setup_options=helpers,
                                numpy_compiled_extensions=numpy_extensions,
                                python_requirements=python_requirements,
                                numpy_requirements=numpy_requirements,
                                excluded_platforms=excluded_platforms,
                                include_extras=include_extras))

    return packages

def render_template(package, template, folder=TEMPLATE_FOLDER):
    """
    Render recipe components from jinja2 templates.

    Parameters
    ----------

    package : Package
        :class:`Package` object for which template will be rendered.
    template : str
        Name of template file, path relative to ``folder``.
    folder : str
        Path to folder containing template.
    """
    full_template_path = os.path.abspath(folder)
    jinja_env = Environment(loader=FileSystemLoader(full_template_path), undefined=PassThroughUndefined)
    tpl = jinja_env.get_template('/'.join([package.conda_name, template]))
    rendered = tpl.render(version=package.version, md5=package.md5)
    return rendered


def inject_requirements(package, recipe_path):
    """
    Two packages get special treatment so that restrictions on build versions,
    which may be more restrictive than the requirements of the package itself.

    Those two packages are python and numpy.
    """
    meta_path = os.path.join(recipe_path, 'meta.yaml')
    with open(meta_path) as f:
        recipe = yaml.load(f, yaml.RoundTripLoader)

    spec = []
    if package.python_requirements:
        spec.append(' '.join(['python', package.python_requirements]))
    if package.numpy_requirements:
        spec.append(' '.join(['numpy', package.numpy_requirements]))

    if spec:
        for section in ['build', 'run']:
            recipe['requirements'][section].extend(spec)

    with open(meta_path, 'w') as f:
        yaml.dump(recipe, f, Dumper=yaml.RoundTripDumper,
                  default_flow_style=False)

def main(args=None):
    """
    Generate recipes for packages either from recipe templates, by copying
    from conda-forge, or by using conda skeleton.
    """
    if args is None:
        parser = ArgumentParser('command line tool for building packages.')
        parser.add_argument('requirements',
                            help='Path to requirements.yml')
        parser.add_argument('--template-dir', default=TEMPLATE_FOLDER,
                            help="Path the folder of recipe templates, if "
                                 "any. Default: '{}'".format(TEMPLATE_FOLDER))
        args = parser.parse_args()
        template_dir = args.template_dir

    packages = get_package_versions(args.requirements)

    packages = [p for p in packages if p.supported_platform]

    try:
        needs_recipe = os.listdir(template_dir)
    except OSError:
        needs_recipe = []

    try:
        os.mkdir(RECIPE_FOLDER)
    except OSError:
        pass

    # Write recipes from templates.
    for p in packages:
        recipe_path = os.path.join(RECIPE_FOLDER, p.conda_name+'-'+p.version)
        template_path = os.path.join(template_dir, p.conda_name)

        print('Writing recipe for {}-{} at {}'.format(p.conda_name, p.version, recipe_path))
        try:
            os.mkdir(recipe_path)
        except OSError:
            pass
        templates = [d for d in os.listdir(template_path) if
                     not d.startswith('.')]

        # render the meta data
        meta_path = os.path.join(template_path, 'meta-%s.yaml' %p.version)
        if not os.path.exists(meta_path):
            meta_path = os.path.join(template_path, 'meta.yaml')
        if not os.path.exists(meta_path):
            raise ValueError("no meta.yaml found for package '%s'" %p.conda_name)

        rendered = render_template(p, os.path.split(meta_path)[-1], folder=template_dir)
        with open(os.path.join(recipe_path, 'meta.yaml'), 'wt') as f:
            f.write(rendered)

        for template in templates:
            if 'meta' in template: continue
            rendered = render_template(p, template, folder=template_dir)
            with open(os.path.join(recipe_path, template), 'wt') as f:
                f.write(rendered)
        inject_requirements(p, recipe_path)

from jinja2.runtime import Undefined

class PassThroughUndefined(Undefined):
    def __str__(self):
        return u'{{ %s }}' % self._undefined_name

    def __call__(self, *args, **kwargs):
        sargs = ', '.join(['"%s"' % a for a in args])
        skwargs = ', '.join(['%s="%s"' % (k, a) for k, a in kwargs.items()])

        return u'{{ %s(%s) }}' % (self._undefined_name, ','.join([sargs, skwargs]))

if __name__ == '__main__':
    main()
