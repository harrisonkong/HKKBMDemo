# HKUIButton
#### HK UIButton Enhancements

## IMPORTANT!! ##

You **MUST** include this script at the end of your Podfile or the Inspectables won't work.

```
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
```

## INTRODUCTION
This class descends from UIButton and provides these enhancements and a designable user interface in Xcode Interface Builder.

### Dynamic Corner Radius
This class descends from UIButton and provides the functionalities to calculate a corner radius dynamically base on one of the sides. It uses the methods in HKUIViewAutoCornerExtension as a base.

### Highlighted and Selected State Customization
It lets users customize the border color, width, alpha of the highlighted, normal and selected states

## Dynamic Text Size
The text size can change dynamically, adopting to different dimensions just like the corner radius.

## HOW IT WORKS

It overrides these four methods to provide the values to `HKUIViewAutoCornerExtension`.

```
    @objc open func autoCornerRoundingBasis() -> LengthCalculationBasis

    @objc open func autoCornerRoundingConstant() -> CGFloat

    @objc open func autoCornerRoundingEnabled() -> Bool

    @objc open func autoCornerRoundingFactor() -> CGFloat

```

It call this method of `HKUIViewAutoCornerExtension` when it needs to redraw.

```
    public func updateCornerRadius()
```

## INSTALLATION

Manually:

Include in your project

```
  HKUIButton.swift
  UIView+HKAutoCornerRounding.swift
  UIView+LengthCalculationBasis.swift
```

Or use CocoaPod. Don't forget to import the module if you are using CocoaPod:

```
  import HKUIButton
```
