require 'formula'

class Ode015 < Formula
  url 'https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz'
  homepage 'http://www.ode.org/'
  #sha1 '0279d58cc390ff5cc048f2baf96cff23887f3838'
  sha256 '889a6e249c2c7deea0c6e812e5334c8d340646502977a29cc942ea8af141f1de'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build

  if ARGV.build_head?
    # Requires newer automake and libtool
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def options
    [
      ["--disable-double-precision", "Configure ODE to work WITHOUT double precision"],
      ["--disable-libccd", "Disable all libccd colliders (except box-cylinder)"],
      ["--enable-demos", "Build and install ODE demos"],
      ["--without-drawstuff", "Build and install WITHOUT Drawstuff"]
    ]
  end

  def install
    args = []
    args << "--disable-demos" unless ARGV.include? "--enable-demos"
    args << "--enable-double-precision" unless ARGV.include? "--disable-double-precision"
    args << "--enable-libccd=internal" unless ARGV.include? "--disable-libccd"

    if ARGV.build_head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      inreplace 'boostrap', 'libtoolize', '$LIBTOOLIZE'
      system "./bootstrap"
    end
    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "(cd drawstuff; make)"
    system "make install"
    unless(ARGV.include?("--without-drawstuff"))
      system "curl -O https://raw.githubusercontent.com/sanoakr/homebrew-slab/master/install_drawstuff.sh"
      system "chmod a+x install_drawstuff.sh"
      system "./install_drawstuff.sh"
    end
  end
end
