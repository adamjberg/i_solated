i_solated
=========

# How to Build

Download [Flex SDK](https://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.6/flex_sdk_4.6.0.23201B.zip)

Run mxmlc from Flex SDK:

```
mxmlc -static-link-runtime-shared-libraries -library-path+=lib/as3-signals-v0.8.swc --source-path=src src/core/Main.as -o bin/Main.swf
```