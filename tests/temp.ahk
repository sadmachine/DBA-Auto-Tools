#Requires AutoHotkey v2.0
#Include <v2/DotEnv>

env := DotEnv(".env")


MsgBox(env("main.test1"))
MsgBox(env("main.asdf"))
MsgBox(env("main.asdf", "default value"))
MsgBox(env("second.asdf", "default value"))
