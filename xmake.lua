set_xmakever("2.5.5")
set_description("Natalie is a work-in-progress implementation of Ruby, compiled to C++.")

add_repositories("my-repo myrepo")
add_requires("gdtoa")
add_requires("onigmo")

target("bindings")
    set_targetdir("build")
    on_build(function (target)
        local generated_dir = path.join(target:targetdir(), "generated")
        os.mkdir(generated_dir)
        local cpp_path = path.join(generated_dir, "bindings.cpp")
        os.vrunv("sh", {"-c", string.format("ruby %s > %s", path.join(os:projectdir(), "lib/natalie/compiler/binding_gen.rb"), cpp_path)})
        target:add("files", cpp_path, {interface = true})
    end)

rule("rb")
    set_extensions(".rb")
    before_build_file(function (target, sourcefile)
        -- make sure generated directory exists
        local generated_dir = path.join(target:targetdir(), "generated")
        os.mkdir(generated_dir)

        -- generate cpp from rb
        local cpp_name = path.basename(sourcefile) .. ".cpp"
        local cpp_path = path.join(generated_dir, cpp_name)
        local natalie = path.join(os:projectdir(), "bin/natalie")
        os.vrunv(natalie, {"--write-obj", cpp_path, sourcefile})

        -- make sure object directory exists
        local outputdir = target:objectdir()
        os.mkdir(outputdir)

        -- compile cpp to object file
        import("core.tool.compiler")
        local obj_path = path.join(outputdir, cpp_name .. ".o")
        compiler.compile(cpp_path, obj_path, {target = target})
        table.join2(target:objectfiles(), obj_path)
    end)

target("platform")
    set_targetdir("build")
    on_build(function (target)
        local generated_dir = path.join(target:targetdir(), "generated")
        os.mkdir(generated_dir)
        local output = os.iorunv("ruby", {"-e", "p RUBY_PLATFORM"})
        local cpp = "#include \"natalie.hpp\"\nconst char *Natalie::ruby_platform = " .. output:match("(.-)%s*$") .. ";\n"
        local cpp_path = path.join(generated_dir, "platform.cpp")
        io.writefile(cpp_path, cpp)
        target:add("files", cpp_path, {interface = true})
    end)

target("natalie")
    set_kind("static")
    set_languages("cxx17")
    set_targetdir("build")
    add_packages("gdtoa")
    add_packages("onigmo")
    add_includedirs("include")
    add_files("src/*.cpp|src/main.cpp")
    add_deps(
        "bindings",
        "platform")
    add_rules("rb")
    add_files("src/*.rb")
    --add_files("$(buildir)/generated/bindings.cpp", {force = true})
    --add_files("$(buildir)/generated/platform.cpp", {force = true})
    before_build(function (target)
        print("here")
        target:add("files", path.join(target:targetdir(), "generated/bindings.cpp"))
        target:add("files", path.join(target:targetdir(), "generated/platform.cpp"))
        os.cp(target:pkg("onigmo")._INFO.sysincludedirs .. "/*.h", target:targetdir() .. "/include/onigmo/")
        os.cp(target:pkg("gdtoa")._INFO.sysincludedirs .. "/*.h", target:targetdir() .. "/include/gdtoa/")
    end)
