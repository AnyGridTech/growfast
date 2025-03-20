; Defina o caminho para o arquivo de log no mesmo diretório do script
logFile := A_ScriptDir "\log.txt"

; Função para formatar a data e hora no formato dd/mm/yyyy hh:mm:ss
GetFormattedDateTime() {
    FormatTime, formattedTime,, dd/MM/yyyy HH:mm:ss
    return formattedTime
}

; Função para registrar no log
LogToFile(logMessage) {
    global logFile
    formattedTime := GetFormattedDateTime()
    FileAppend, %formattedTime% - %logMessage%n, %logFile%
}

; Atalho para abrir os links dos tickets
!A::
    ; Limpar a área de transferência
    Clipboard := ""
    ; Copiar o conteúdo da área de transferência
    Send, ^c
    ; Esperar um curto período de tempo para garantir que a área de transferência seja atualizada
    Sleep, 100
    ; Recuperar o texto da área de transferência
    TicketNumbers := Clipboard
    ; Verificar se há algum número de ticket na área de transferência
    if (TicketNumbers != "" && RegExMatch(TicketNumbers, "\d"))
    {
        ; Dividir os números de ticket com base nas quebras de linha
        TicketList := StrSplit(TicketNumbers, "`n")

        ; Iterar sobre cada linha de texto encontrada
        Loop, % TicketList.MaxIndex()
        {
            ; Remover todos os caracteres não numéricos e dividir os tickets por espaço ou vírgula
            Line := RegExReplace(TicketList[A_Index], "[^\d\s,]", " ")
            Loop, Parse, Line, %A_Space%
            {
                TicketNumber := Trim(A_LoopField)
                ; Construir o URL com o número do ticket
                if (TicketNumber != "")
                {
                    URL := "https://growatt.movidesk.com/Ticket/edit/" TicketNumber
                    ; Abrir o URL no navegador padrão
                    Run, %URL%
                    
                    ; Registrar a abertura do ticket no log
                    LogToFile("URL: " . URL)
                }
            }
        }
    }
    else
    {
        ; Se não houver número de ticket na área de transferência
        MsgBox, FALHA: Nenhum ticket encontrado.

        ; Registrar a falha no log
        LogToFile("Falha: Nenhum ticket encontrado.")
    }
return
