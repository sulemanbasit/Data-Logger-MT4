#!/bin/bash

vs_code_path="C:\Users\asbas\AppData\Roaming\MetaQuotes\Terminal\03C90BB4CD8026339921C49182082508\MQL4"

github_path="D:\User\asbasit\Data-Logger-MT4"

file_mq4="TradingDataLog.mq4"
file_ex4="TradingDataLog.ex4"

cp "$vs_code_path\$file_mq4" "$github_path"
cp "$vs_code_path\$file_ex4" "$github_path"
