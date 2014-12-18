require 'formula'

class OdeDrawstuff < Formula
  url 'http://sourceforge.net/projects/opende/files/ODE/0.13/ode-0.13.tar.bz2'
  homepage 'http://www.ode.org/'
#  sha1 '93930249a503ce8d09aee1f50be54c7c7f18d7e113f4be3d78ae947b3bbfef17'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build

  if ARGV.build_head?
    # Requires newer automake and libtool
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def options
    [
      ["--disable-double-precision", "Configure ODE to work without double precision"],
      ["--disable-libccd", "Disable all libccd colliders (except box-cylinder)"],
      ["--enable-demos", "Build and install Drawstuff"],
      ["--with-drawstuff", "Build and install Drawstuff"]
    ]
  end

  def install
    args = []
    args << "--disable-demos" unless ARGV.include? "--enable-demos"
    args << "--enable-double-precision" unless ARGV.include? "--disable-double-precision"
    args << "--enable-libccd" unless ARGV.include? "--disable-libccd"

    if ARGV.build_head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      inreplace 'boostrap', 'libtoolize', '$LIBTOOLIZE'
      system "./bootstrap"
    end
    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make install"
    if(ARGV.include?("--with-drawstuff"))
      system "curl -O https://raw.githubusercontent.com/sanoakr/homebrew-slab/master/install_drawstaff.sh"
      system "chmod a+x install_drawstuff.sh"
      system "./install_drawstuff.sh"
    end
  end
end
