param (
    [Parameter(Mandatory=\$true)]
    [string]\$Prompt
)

# Set up the connection payload for the AI model
\$body = @{ 
    model = "llama3"
    prompt = \$Prompt
    stream = \$false 
} | ConvertTo-Json

# Send the prompt to the local Ollama server
try {
    \$response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body \$body -ContentType "application/json"
    Write-Host "`n[AI Response]:" -ForegroundColor Cyan
    Write-Host $response.response
} catch {
    Write-Host "`n[Error]: Make sure Ollama is running and Llama 3 is installed." -ForegroundColor Red
}
