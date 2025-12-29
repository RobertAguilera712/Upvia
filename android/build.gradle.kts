// android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 1. Setup custom build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()

rootProject.layout.buildDirectory.value(newBuildDir)

// 2. Configure subprojects for build directory and SDK overrides
subprojects {
    // Set subproject build directories
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // FORCE SDK VERSION & NAMESPACE FIX
    // This targets the Android plugin directly to avoid "afterEvaluate" errors
    plugins.withType<com.android.build.gradle.BasePlugin> {
        val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
        
        // Fix for 'lStar' error: Force every library to compile with at least SDK 34
        android.compileSdkVersion(34)
        android.buildToolsVersion("34.0.0")

        // Fix for 'Namespace not specified': Required for older versions of Isar
        if (android.namespace == null) {
            android.namespace = when (project.name) {
                "isar_flutter_libs" -> "dev.isar.isar_flutter_libs"
                else -> project.group.toString().ifEmpty { "com.fallback.${project.name}" }
            }
        }
    }
}

// 3. Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}