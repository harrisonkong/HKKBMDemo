platform :ios, '13.0'

target 'HKKBMDemo' do

  # uncomment the following line to use frameworks, leave it commented to use static libraries

  use_frameworks!
  pod 'HKUIButton', '~> 1.0.0'
  pod 'HKUIImageView', '~> 1.0.0'
  pod 'HKUIKeyboardManager', '~> 1.0.0'
  pod 'HKUIView', '~> 1.0.0'
  pod 'HKUIViewLengthCalculationBasis', '~> 1.0.0'
  pod 'HKUIViewAutoCornerExtension', '~> 1.0.0'
end

# This post_install section fixes a bug in CocoaPod that does not allow
# IBDesignables to render in interface builder

post_install do |installer|
installer.pods_project.targets.each do |target|
    target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
end
