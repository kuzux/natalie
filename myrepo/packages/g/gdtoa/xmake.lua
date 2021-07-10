package("gdtoa")
    set_homepage("https://github.com/jwiegley/gdtoa")
    set_description("David M. Gay's floating-point conversion library")

    add_urls("https://github.com/jwiegley/gdtoa.git")

    add_includedirs("include/gdtoa", {public = true})

    on_install("linux", "macosx", "bsd", function (package)
        local configs = {}
        if package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end
        import("package.tools.autoconf").install(package, configs)
        os.cp("arith.h", package:installdir("include/gdtoa"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("dtoa", {includes = "gdtoa.h"}))
    end)
