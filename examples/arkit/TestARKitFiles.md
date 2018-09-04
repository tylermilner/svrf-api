# Adding test files to ARKit Test App

## Open Xcode

1. Open `./ARKitFaceExample.xcworkspace`.

## Copy the test files into Xcode

1. Create a new folder in `./ARKitFaceExample/Resources/Model.scnassets/`.
2. Copy the `.dae` file and associated texture files you'd like to test.
3. Paste the files into the new folder you created (`./ARKitFaceExample/Resources/Model.scnassets/<New Folder>`).

## Convert to a SceneKit file

1. In Xcode open the `.dae` file.
2. In the Xcode navbar select `Editor > Convert to SceneKit scene file format (.scn)`

## Add it to the scene

1. In Xcode open `ViewController.swift`.
2. Update the `modelName` with the `.scn` file name, and `modelPath` with the file path.

## Test

1. Make sure the test device used is a real iPhoneX and not a simulator.
2. Run your app using the play button.
