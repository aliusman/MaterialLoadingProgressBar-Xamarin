echo OFF
cls
:: Clear build directories
:: Clear library project build directories
rmdir /s /q "library\bin"
rmdir /s /q "library\obj"

:: Clear sample project build directories
rmdir /s /q "samples\MaterialLoadingProgressBar-Sample\bin"
rmdir /s /q "samples\MaterialLoadingProgressBar-Sample\obj"

:: Build sample project to ensure that binded library referenced correctly.
msbuild.exe "/p:Configuration=Release" /t:SignAndroidPackage samples\MaterialLoadingProgressBar-Sample\MaterialLoadingProgressBar-Sample.csproj
::msbuild.exe "/p:Configuration=Release;AdbTarget=-d -r" /t:Clean,Install samples\MaterialLoadingProgressBar-Sample\MaterialLoadingProgressBar-Sample.csproj
if %errorlevel% neq 0 goto :sample_build_error

:: Create NuGet package
dev\.nuget\NuGet.exe pack dev\Lsjwzh.MaterialLoadingProgressBar.Xamarin.Android.nuspec
if %errorlevel% neq 0 goto :nuget_package_error

goto :success

:sample_build_error
echo "Failed to build sample project."
exit /b %errorlevel%

:nuget_package_error
echo "Failed to create nuget package."
exit /b %errorlevel%

:success
echo "Successfully built project."

