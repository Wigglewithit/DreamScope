allprojects {
    repositories {
        google()
        mavenCentral()
    }
}



// Configure the root project build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Update the build directory for each subproject
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Ensure the 'app' module is evaluated before this subproject
    if (project.name != "app") {
        project.evaluationDependsOn(":app")
    }
}

// Define the clean task for deleting the root build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}