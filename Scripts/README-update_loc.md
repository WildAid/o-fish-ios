# update_loc.swift

A Swift script that fill find missing string localizations and append them to the bottom of each Localizable.strings file.

## Setup
In the project Scripts directory.
```bash
chmod +x ./update_loc.swift
```

## Usage

```bash
./update_loc.swift --source_path={Source Location} --loc_path={Localization Root Directory}
```

<b>e.g.</b>
```bash
./update_loc.swift --source_path=/Projects/o-fish-ios/o-fish-ios --loc_path=/Projects/o-fish-ios/Localization/
```

## Flags
- --loc_path= Localization Directory {Required}
- --source_path= Source Files Directory {Required}
- --backup_path= Loc File BackUp Location {Optional - Defaults to Script/Backup}
- --verbose= Show Info Messages {Optional - true/false; Default = false}
- --test= Show Missing Keys without Making Changes {Optional - true/false; Default = false} 
- --help {Prints out commands}

## How Does It Work?
- Makes a backup of current Localization files to the directory from which run or --backup_path if supplied
- Runs genstrings for Swift source files in --source_path
- Collects the keys for unlocalized string from above
- Loads each localization file and identifies any missing keys
- Appends missing keys to the end of each localization file

## About genstrings
- Finds only strings that match a pattern where used within the NSLocalizedString() function or, with SwiftUI, within Text()
- Raw strings, such as on straight variable declarations will not be found because genstrings keys off the pattern matches and doesn't match straight strings.
```swift
var myString = "some Non-Localized string" // won't be detected
var myString = NSLocalizedString("some Non-Localized string", comment: "") // will be detected
```

- Additional patterns can be added - such as where a control or function is added that works like Text().  
- These can be added within the labelled section in the method 
```swift
genStrings(sourcePath: String, backUpDirPath: String? = nil)
```

## License
[MIT](https://choosealicense.com/licenses/mit/)