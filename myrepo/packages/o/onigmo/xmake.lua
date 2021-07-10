package("onigmo")
    set_homepage("https://github.com/k-takata/Onigmo")
    set_description("Onigmo is a regular expressions library forked from Oniguruma.")

    add_urls("https://github.com/k-takata/Onigmo/releases/download/Onigmo-$(version)/onigmo-$(version).tar.gz")
    add_versions("6.2.0", "c648496b5339953b925ebf44b8de356feda8d3428fa07dc1db95bfe2570feb76")

    add_includedirs("include", {public = true})

    on_install("linux", "macosx", "bsd", function (package)
        local configs = {}
        if package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("onig_new", {includes = "onigmo.h"}))
    end)
