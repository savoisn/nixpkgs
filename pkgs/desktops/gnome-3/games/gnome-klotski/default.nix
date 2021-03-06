{ stdenv, fetchurl, pkgconfig, vala, gnome3, gtk3, wrapGAppsHook, appstream-glib, desktop-file-utils
, glib, librsvg, libxml2, gettext, itstool, libgee, libgnome-games-support
, meson, ninja, python3
}:

let
  pname = "gnome-klotski";
  version = "3.34.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1bg7hl64lmjryzvp51qfak5jqs7vbqfmj0s7h1g3c7snscca7rx6";
  };

  nativeBuildInputs = [
    pkgconfig vala meson ninja python3 wrapGAppsHook
    gettext itstool libxml2 appstream-glib desktop-file-utils
    gnome3.adwaita-icon-theme
  ];
  buildInputs = [ glib gtk3 librsvg libgee libgnome-games-support ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Klotski;
    description = "Slide blocks to solve the puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
