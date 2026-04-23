
extern crate cc;

fn main() {
    println!("cargo:rustc-link-lib=dylib=MobileGestalt");

    cc::Build::new()
        .file("src/c/relay.c")
        .file("src/c/absdUser.c")
        .compile("relay");
}
