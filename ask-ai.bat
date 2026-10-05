@echo off
title CmdGPT - Offline AI Workspace
cls
setlocal enabledelayedexpansion

:: Initialize chat tracking variables
set "current_chat=New_Chat"
set "chat1=New_Chat"
set "chat2=Empty"
set "chat3=Empty"

:menu
cls
echo ===================================================
echo             WELCOME TO CmdGPT v1.2.0               
echo        Powered Offline by Ollama and Llama 3       
echo ===================================================
echo  ACTIVE CHAT SLOT: [%current_chat%]
echo ===================================================
echo  1. Start New Chat (Talk with the AI)
echo  2. Rename Current Chat
echo  3. Switch Between Previous Chats
echo  4. Exit Program
echo ===================================================
echo.

set /p menu_choice="Choose an option (1-4): "

if "%menu_choice%"=="1" goto chat_loop
if "%menu_choice%"=="2" goto rename_chat
if "%menu_choice%"=="3" goto switch_menu
if "%menu_choice%"=="4" goto end

:: If they type something else, send them back to the menu
echo Invalid choice, please try again.
timeout /t 2 >nul
goto menu


:chat_loop
cls
echo ===================================================
echo  TALKING TO AI IN CHAT: [%current_chat%]
echo  (Type 'menu' to go back to the main menu)
echo ===================================================
echo.

:prompt_inner
set /p user_prompt="CmdGPT > "

if "%user_prompt%"=="menu" goto menu

echo.
echo [CmdGPT is thinking...]
echo.

:: Send the prompt over to the local Ollama brain
curl -s -X POST http://localhost:11434/api/generate ^
  -H "Content-Type: application/json" ^
  -d "{\"model\": \"llama3\", \"prompt\": \"%user_prompt%\", \"stream\": false}"

echo.
echo ---------------------------------------------------
goto prompt_inner


:rename_chat
cls
echo ===================================================
echo                 RENAME YOUR CHAT                    
echo ===================================================
echo  Current name: %current_chat%
echo.
set /p new_name="Enter new name for this chat: "

:: Remove spaces seamlessly if they add any so formatting stays clean
set "clean_name=%new_name: =_%"

:: Update both the active name and save it in the history slot
if "%current_chat%"=="%chat1%" (set "chat1=%clean_name%")
if "%current_chat%"=="%chat2%" (set "chat2=%clean_name%")
if "%current_chat%"=="%chat3%" (set "chat3=%clean_name%")
set "current_chat=%clean_name%"

echo.
echo [Success] Chat name updated to: [%current_chat%]
timeout /t 2 >nul
goto menu


:switch_menu
cls
echo ===================================================
echo             SWITCH TO A PREVIOUS CHAT              
echo ===================================================
echo  1. %chat1%
echo  2. %chat2%
echo  3. %chat3%
echo  4. [Back to Main Menu]
echo ===================================================
echo.
set /p slot_choice="Select a chat slot (1-4): "

if "%slot_choice%"=="1" (
    set "current_chat=%chat1%"
    goto menu
)
if "%slot_choice%"=="2" (
    :: If slot is empty, initialize it as 'New_Chat'
    if "%chat2%"=="Empty" (set "chat2=New_Chat")
    set "current_chat=%chat2%"
    goto menu
)
if "%slot_choice%"=="3" (
    if "%chat3%"=="Empty" (set "chat3=New_Chat")
    set "current_chat=%chat3%"
    goto menu
)
if "%slot_choice%"=="4" goto menu

echo Invalid choice.
timeout /t 2 >nul
goto switch_menu


:end
cls
echo ===================================================
echo  Thank you for using CmdGPT! Goodbye.
echo ===================================================
timeout /t 3 >nul
exit
