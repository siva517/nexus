pkg_origin=sthumati
pkg_name="nexus"
pkg_maintainer="Sivakrishna <siva517>"
pkg_description="Sonatype Nexus Reposiroty Manager"
pkg_upstream_url="https://www.sonatype.com"

pkg_license=("Apache-2.0")

pkg_major="3"
pkg_minor="19"
pkg_patch="1"
pkg_rev="01"
pkg_version="${pkg_major}.${pkg_minor}.${pkg_patch}"
pkg_fq_version="${pkg_version}-${pkg_rev}"

pkg_filename="nexus-${pkg_fq_version}-unix.tar.gz"
pkg_source="https://sonatype-download.global.ssl.fastly.net/repository/repositoryManager/${pkg_major}/nexus-${pkg_fq_version}-unix.tar.gz"
pkg_shasum="7a2e62848abeb047c99e114b3613d29b4afbd635b03a19842efdcd6b6cb95f4e"

# Dependencies
pkg_deps=(core/openjdk11/11.0.2/20190611004012)

# Paths to the application
pkg_bin_dirs=(nexus-$pkg_fq_version/bin)
pkg_lib_dirs=(nexus-$pkg_fq_version/lib)

pkg_exports=(
  [port]=port
)
pkg_exposes=(port)

# Don't run Nexus as root !!!
pkg_svc_user="hab"
pkg_svc_group="$pkg_svc_user"

do_build() {
  return 0
}

do_install() {
  # Copy across the Nexus binaries
  tar xvPf $HAB_CACHE_SRC_PATH/${pkg_filename} -C $pkg_prefix

  # Then copy across the template sonatype-work directory. We'll use this to construct the default repo
  # under /hab/svc which will persist across upgrades.
  cp -R $HAB_CACHE_SRC_PATH/sonatype-work $pkg_prefix

  # Remove default config file and symlink it to dynamic config
#  rm $pkg_prefix/nexus-$pkg_fq_version/bin/nexus.vmoptions
#  ln -s /hab/svc/nexus/config/nexus.vmoptions $pkg_prefix/nexus-$pkg_fq_version/bin/nexus.vmoptions

#if [ -f "${pkg_prefix}/nexus-${pkg_fq_version}/etc/nexus-default.properties" ] ; then
#  echo "Removing old Nexus customisations"
#  unlink ${pkg_prefix}/nexus-${pkg_fq_version}/etc/nexus-default.properties
#fi
#echo "Connecting dynamic Nexus customisations"
#ln -s /hab/svc/nexus/config/nexus.properties $pkg_prefix/nexus-$pkg_fq_version/etc/nexus-default.properties
#

if [ -f "${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.vmoptions" ] ; then
  echo "Removing old Nexus customisations"
  rm ${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.vmoptions
  ln -s /hab/svc/nexus/config/nexus.vmoptions ${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.vmoptions
fi

if [ -f "${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.rc" ] ; then
  echo "Removing old Nexus customisations"
  rm ${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.rc
  ln -s /hab/svc/nexus/config/nexus.rc ${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.rc
fi

if [ -f "${pkg_prefix}/nexus-${pkg_fq_version}/bin/nexus.properties" ] ; then
  echo "Removing old Nexus customisations"
  rm ${pkg_prefix}/nexus-${pkg_fq_version}/etc/nexus-default.properties
  ln -s /hab/svc/nexus/config/nexus.properties ${pkg_prefix}/nexus-${pkg_fq_version}/etc/nexus.properties
fi
#
#echo "Connecting dynamic Nexus customisations"
#ln -s /hab/svc/nexus/config/nexus $pkg_prefix/nexus-$pkg_fq_version/bin/nexus
  return 0
}

