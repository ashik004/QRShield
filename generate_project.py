import os
import hashlib
import sys

def gen_id(name):
    # Generates a deterministic 24-character hex ID like Xcode PBX
    return hashlib.md5(name.encode('utf-8')).hexdigest()[:24].upper()

root_dir = "/Users/applestudio/.gemini/antigravity/scratch/QRShield"
sources_dir = os.path.join(root_dir, "Sources", "QRShield")

# Gather all files in Sources/QRShield
file_tree = {
    "Models": [],
    "Services": [],
    "Views/Components": [],
    "Views/Screens": [],
    "Views": [],
    "Root": []
}

for root, dirs, files in os.walk(sources_dir):
    for f in sorted(files):
        if not f.endswith(".swift"):
            continue
        rel_path = os.path.relpath(root, sources_dir)
        if rel_path == ".":
            file_tree["Root"].append(f)
        elif rel_path in file_tree:
            file_tree[rel_path].append(f)
        else:
            file_tree[rel_path] = [f]

# Create IDs
build_files = [] # (build_id, file_id, filename)
file_refs = []   # (file_id, filename, path)

for group, f_list in file_tree.items():
    for f in f_list:
        file_id = gen_id(f"FILEREF_{group}_{f}")
        build_id = gen_id(f"BUILDFILE_{group}_{f}")
        build_files.append((build_id, file_id, f))
        file_refs.append((file_id, f, f))

# Group hierarchy
proj_id = gen_id("PROJECT_QRShield")
main_group_id = gen_id("MAINGROUP")
sources_group_id = gen_id("SOURCES_GROUP")
qrshield_group_id = gen_id("QRSHIELD_GROUP")
models_group_id = gen_id("MODELS_GROUP")
services_group_id = gen_id("SERVICES_GROUP")
views_group_id = gen_id("VIEWS_GROUP")
components_group_id = gen_id("COMPONENTS_GROUP")
screens_group_id = gen_id("SCREENS_GROUP")
products_group_id = gen_id("PRODUCTS_GROUP")

app_product_id = gen_id("PRODUCT_APP")
native_target_id = gen_id("TARGET_QRShield")
sources_build_phase_id = gen_id("SOURCES_BUILD_PHASE")
frameworks_build_phase_id = gen_id("FRAMEWORKS_BUILD_PHASE")
resources_build_phase_id = gen_id("RESOURCES_BUILD_PHASE")

proj_config_list_id = gen_id("PROJ_CONFIG_LIST")
target_config_list_id = gen_id("TARGET_CONFIG_LIST")
proj_debug_config_id = gen_id("PROJ_DEBUG_CONFIG")
proj_release_config_id = gen_id("PROJ_RELEASE_CONFIG")
target_debug_config_id = gen_id("TARGET_DEBUG_CONFIG")
target_release_config_id = gen_id("TARGET_RELEASE_CONFIG")

# Generate project.pbxproj content
pbx = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
"""

for bid, fid, fname in build_files:
    pbx += f"\t\t{bid} /* {fname} in Sources */ = {{isa = PBXBuildFile; fileRef = {fid} /* {fname} */; }};\n"

pbx += """/* End PBXBuildFile section */

/* Begin PBXFileReference section */
"""

for fid, fname, fpath in file_refs:
    pbx += f'\t\t{fid} /* {fname} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{fname}"; sourceTree = "<group>"; }};\n'

pbx += f'\t\t{app_product_id} /* QRShield.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = QRShield.app; sourceTree = BUILT_PRODUCTS_DIR; }};\n'

pbx += """/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
"""
pbx += f"""\t\t{frameworks_build_phase_id} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
"""

# Main group
pbx += f"""\t\t{main_group_id} = {{
			isa = PBXGroup;
			children = (
				{sources_group_id} /* Sources */,
				{products_group_id} /* Products */,
			);
			sourceTree = "<group>";
		}};
"""

# Sources group
pbx += f"""\t\t{sources_group_id} /* Sources */ = {{
			isa = PBXGroup;
			children = (
				{qrshield_group_id} /* QRShield */,
			);
			path = "Sources";
			sourceTree = "<group>";
		}};
"""

# QRShield group
root_children = [f"\t\t\t\t{models_group_id} /* Models */,",
                 f"\t\t\t\t{services_group_id} /* Services */,",
                 f"\t\t\t\t{views_group_id} /* Views */,"]
for f in file_tree["Root"]:
    fid = gen_id(f"FILEREF_Root_{f}")
    root_children.append(f"\t\t\t\t{fid} /* {f} */,")

pbx += f"""\t\t{qrshield_group_id} /* QRShield */ = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(root_children)}
			);
			path = "QRShield";
			sourceTree = "<group>";
		}};
"""

# Models group
models_children = []
for f in file_tree["Models"]:
    fid = gen_id(f"FILEREF_Models_{f}")
    models_children.append(f"\t\t\t\t{fid} /* {f} */,")
pbx += f"""\t\t{models_group_id} /* Models */ = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(models_children)}
			);
			path = "Models";
			sourceTree = "<group>";
		}};
"""

# Services group
services_children = []
for f in file_tree["Services"]:
    fid = gen_id(f"FILEREF_Services_{f}")
    services_children.append(f"\t\t\t\t{fid} /* {f} */,")
pbx += f"""\t\t{services_group_id} /* Services */ = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(services_children)}
			);
			path = "Services";
			sourceTree = "<group>";
		}};
"""

# Views group
views_children = [f"\t\t\t\t{components_group_id} /* Components */,",
                  f"\t\t\t\t{screens_group_id} /* Screens */,"]
for f in file_tree["Views"]:
    fid = gen_id(f"FILEREF_Views_{f}")
    views_children.append(f"\t\t\t\t{fid} /* {f} */,")
pbx += f"""\t\t{views_group_id} /* Views */ = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(views_children)}
			);
			path = "Views";
			sourceTree = "<group>";
		}};
"""

# Components group
comp_children = []
for f in file_tree["Views/Components"]:
    fid = gen_id(f"FILEREF_Views/Components_{f}")
    comp_children.append(f"\t\t\t\t{fid} /* {f} */,")
pbx += f"""\t\t{components_group_id} /* Components */ = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(comp_children)}
			);
			path = "Components";
			sourceTree = "<group>";
		}};
"""

# Screens group
screen_children = []
for f in file_tree["Views/Screens"]:
    fid = gen_id(f"FILEREF_Views/Screens_{f}")
    screen_children.append(f"\t\t\t\t{fid} /* {f} */,")
pbx += f"""\t\t{screens_group_id} /* Screens */ = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(screen_children)}
			);
			path = "Screens";
			sourceTree = "<group>";
		}};
"""

# Products group
pbx += f"""\t\t{products_group_id} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{app_product_id} /* QRShield.app */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{native_target_id} /* QRShield */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {target_config_list_id} /* Build configuration list for PBXNativeTarget "QRShield" */;
			buildPhases = (
				{sources_build_phase_id} /* Sources */,
				{frameworks_build_phase_id} /* Frameworks */,
				{resources_build_phase_id} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = QRShield;
			productName = QRShield;
			productReference = {app_product_id} /* QRShield.app */;
			productType = "com.apple.product-type.application";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{proj_id} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1600;
				LastUpgradeCheck = 1600;
				TargetAttributes = {{
					{native_target_id} = {{
						CreatedOnToolsVersion = 16.0;
					}};
				}};
			}};
			buildConfigurationList = {proj_config_list_id} /* Build configuration list for PBXProject "QRShield" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = {main_group_id};
			productRefGroup = {products_group_id} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{native_target_id} /* QRShield */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{resources_build_phase_id} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{sources_build_phase_id} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
"""

for bid, fid, fname in build_files:
    pbx += f"\t\t\t\t{bid} /* {fname} in Sources */,\n"

pbx += f"""			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		{proj_debug_config_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
			}};
			name = Debug;
		}};
		{proj_release_config_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_OPTIMIZATION_LEVEL = s;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = "wholemodule";
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				SWIFT_VERSION = 5.0;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{target_debug_config_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_CFBundleDisplayName = "QR Shield";
				INFOPLIST_KEY_NSCameraUsageDescription = "QR Shield uses your camera to scan and analyze QR codes for security.";
				INFOPLIST_KEY_NSPhotoLibraryAddUsageDescription = "QR Shield saves your styled QR codes directly to your Photo Library.";
				INFOPLIST_KEY_NSPhotoLibraryUsageDescription = "QR Shield allows you to choose images to scan and embed custom logos.";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.qrshield.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator macosx";
				SUPPORTS_MACCATALYST = NO;
				SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{target_release_config_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_CFBundleDisplayName = "QR Shield";
				INFOPLIST_KEY_NSCameraUsageDescription = "QR Shield uses your camera to scan and analyze QR codes for security.";
				INFOPLIST_KEY_NSPhotoLibraryAddUsageDescription = "QR Shield saves your styled QR codes directly to your Photo Library.";
				INFOPLIST_KEY_NSPhotoLibraryUsageDescription = "QR Shield allows you to choose images to scan and embed custom logos.";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.qrshield.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator macosx";
				SUPPORTS_MACCATALYST = NO;
				SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{proj_config_list_id} /* Build configuration list for PBXProject "QRShield" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{proj_debug_config_id} /* Debug */,
				{proj_release_config_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{target_config_list_id} /* Build configuration list for PBXNativeTarget "QRShield" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{target_debug_config_id} /* Debug */,
				{target_release_config_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */

	}};
	rootObject = {proj_id} /* Project object */;
}}
"""

xcodeproj_dir = os.path.join(root_dir, "QRShield.xcodeproj")
os.makedirs(xcodeproj_dir, exist_ok=True)
pbx_path = os.path.join(xcodeproj_dir, "project.pbxproj")
with open(pbx_path, "w") as f:
    f.write(pbx)

# Create shared scheme
scheme_dir = os.path.join(xcodeproj_dir, "xcshareddata", "xcschemes")
os.makedirs(scheme_dir, exist_ok=True)

scheme_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1600"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES"
      buildArchitectures = "Automatic">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{native_target_id}"
               BuildableName = "QRShield.app"
               BlueprintName = "QRShield"
               ReferencedContainer = "container:QRShield.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{native_target_id}"
            BuildableName = "QRShield.app"
            BlueprintName = "QRShield"
            ReferencedContainer = "container:QRShield.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileOperation
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{native_target_id}"
            BuildableName = "QRShield.app"
            BlueprintName = "QRShield"
            ReferencedContainer = "container:QRShield.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileOperation>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""

with open(os.path.join(scheme_dir, "QRShield.xcscheme"), "w") as f:
    f.write(scheme_content)

print("Generated QRShield.xcodeproj successfully!")
