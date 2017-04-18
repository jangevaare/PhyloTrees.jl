# Only run coverage from linux Julia nightly build on travis.
get(ENV, "TRAVIS_OS_NAME", "")       == "linux"   || exit()
get(ENV, "TRAVIS_JULIA_VERSION", "") == "nightly" || exit()

Pkg.add("Coverage")
using Coverage

cd(joinpath(dirname(@__FILE__), "..")) do
    processed = process_folder()
    Codecov.submit(processed)
end
