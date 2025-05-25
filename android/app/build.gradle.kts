plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.thuthach7ngay"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
        freeCompilerArgs += listOf("-Xjvm-default=all")
    }

    defaultConfig {
        applicationId = "com.example.thuthach7ngay"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    lint {
        disable += "InvalidPackage"
        checkReleaseBuilds = false
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "META-INF/*.kotlin_module"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // implementation(platform("com.google.firebase:firebase-bom:32.7.2"))
    // implementation("com.google.firebase:firebase-analytics")
    // implementation("com.google.android.gms:play-services-auth:20.7.0")
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.22")
    // implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.22")
    // implementation("androidx.multidex:multidex:2.0.1")
    // implementation("androidx.window:window:1.2.0")
    // implementation("androidx.window:window-java:1.2.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
