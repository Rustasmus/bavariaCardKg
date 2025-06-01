plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.bavaria.bavaria"
    compileSdk = 35 // flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "kg.bavaria.bmw"
        minSdk = 21 // flutter.minSdkVersion
        targetSdk = 34 // flutter.targetSdkVersion
        versionCode = 1 // flutter.versionCode
        versionName = "1.0" // flutter.versionName
    }

    buildFeatures {
        buildConfig = true // ✅ Включаем генерацию BuildConfig
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            buildConfigField("boolean", "SHRINK_RESOURCES", "true")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        // release 
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
        //    signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-analytics")
}