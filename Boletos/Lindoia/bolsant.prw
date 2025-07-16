#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOLSANT   ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do boleto grafico santander.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BOLSANT()

oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )

#define DS_MODALFRAME   128
DEFINE MsDialog oDlg1 From 0,0 To 350,300 Title "EMISSÃO DE BOLETOS" Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.
//oDlg1:lTEscClose := .F.
                      
oSay1      := TSay():New( 05,25,{||"EMISSÃO DE BOLETOS"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oSay1      := TSay():New( 20,45,{||"      BANCO       "},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oTBitmap1  := TBitmap():New(35,30,150,150,,"LOGO_SANTANDER.PNG",.T.,oDlg1,,,.F.,.F.,,,.F.,,.T.,,.F.)

oBtn1      := TButton():New( 150,025,"OK",oDlg1,{|| OK()},035,015,,oFont2,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 150,100,"Cancelar",oDlg1,{|| oDlg1:End()},035,015,,oFont2,,.T.,,"",,,,.F. )

ACTIVATE DIALOG oDlg1 CENTERED
Return(.T.)

Static Function OK()    

Local aRegs		:= {}
Local aTitulos	:= {}
Local nLastKey	:= 0
Local cTamanho	:= "M"
Local cDesc1	:= "Este programa tem como objetivo efetuar a impressão do"
Local cDesc2	:= "Boleto de Cobrança com código de barras, conforme os"
Local cDesc3	:= "parâmetros definidos pelo usuário"
Local cString	:= "SE1"
Local cPerg		:= "XINSDS1XZT"
Local wnrel		:= "BOLETO"
Private cStatus := 1
Private lEnd	:= .F.
Private aReturn	:= {	"Banco",;	// [1]= Tipo de Formulário
1,;						  			// [2]= Número de Vias
"Administração",;		  			// [3]= Destinatário
2,;						 			// [4]= Formato 1=Comprimido 2=Normal
2,;						 			// [5]= Mídia 1=Disco 2=Impressora
1,;									// [6]= Porta LPT1, LPT2, Etc
"",;					  			// [7]= Expressão do Filtro
1 ;									// [8]= ordem a ser selecionada
}
Private cTitulo	:= "Boleto de Cobrança com Código de Barras"

Close(oDlg1)

// Monta array com as perguntas
aAdd(aRegs,{	cPerg,;								// Grupo de perguntas
"01",;										     	// Sequencia
"Prefixo Inicial",;							        // Nome da pergunta
"",;								  				// Nome da pergunta em espanhol
"",;												// Nome da pergunta em ingles
"mv_ch1",;						 				    // Variável
"C",;								 				// Tipo do campo
03,;								  				// Tamanho do campo
0,;											     	// Decimal do campo
0,;											     	// Pré-selecionado quando for choice
"G",;												// Tipo de seleção (Get ou Choice)
"",;								  				// Validação do campo
"MV_PAR01",;					  			    	// 1a. Variável disponível no programa
"",;		  										// 1a. Definição da variável - quando choice
"",;												// 1a. Definição variável em espanhol - quando choice
"",;												// 1a. Definição variável em ingles - quando choice
"",;												// 1o. Conteúdo variável
"",;												// 2a. Variável disponível no programa
"",;												// 2a. Definição da variável
"",;												// 2a. Definição variável em espanhol
"",;												// 2a. Definição variável em ingles
"",;												// 2o. Conteúdo variável
"",;									 			// 3a. Variável disponível no programa
"",;									 			// 3a. Definição da variável
"",;									 			// 3a. Definição variável em espanhol
"",;									 			// 3a. Definição variável em ingles
"",;									 			// 3o. Conteúdo variável
"",;												// 4a. Variável disponível no programa
"",;												// 4a. Definição da variável
"",;									 			// 4a. Definição variável em espanhol
"",;									 			// 4a. Definição variável em ingles
"",;									 			// 4o. Conteúdo variável
"",;									 			// 5a. Variável disponível no programa
"",;									 			// 5a. Definição da variável
"",;									 			// 5a. Definição variável em espanhol
"",;												// 5a. Definição variável em ingles
"",;									 			// 5o. Conteúdo variável
"",;								  				// F3 para o campo
"",;									 			// Identificador do PYME
"",;									 			// Grupo do SXG
"",;									  			// Help do campo
"" })									 			// Picture do campo
aAdd(aRegs,{cPerg,"02","Prefixo Final",			"","","mv_ch2","C",03,0,0,"G","","MV_PAR02","",	"",		"",		"zzz",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","","" })

aTamSX3	:= TAMSX3("E1_NUM")
aAdd(aRegs,{cPerg,"03","Numero Inicial", 		"","","mv_ch3","C",aTamSx3[1],0,0,"G","","MV_PAR03","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"04","Numero Final",			"","","mv_ch4","C",aTamSx3[1],0,0,"G","","MV_PAR04","",	"",		"",		"zzzzzz",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

aTamSX3	:= TAMSX3("E1_PARCELA")
aAdd(aRegs,{cPerg,"05","Parcela Inicial",		"","","mv_ch5","C",aTamSx3[1],0,0,"G","","MV_PAR05","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"06","Parcela Final",			"","","mv_ch6","C",aTamSx3[1],0,0,"G","","MV_PAR06","",	"",		"",		"z",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

aAdd(aRegs,{cPerg,"07","Tipo Inicial",			"","","mv_ch7","C",03,0,0,"G","","MV_PAR07","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"08","Tipo Final",			"","","mv_ch8","C",03,0,0,"G","","MV_PAR08","",	"",		"",		"zzz",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"09","Cliente Inicial",		"","","mv_ch9","C",06,0,0,"G","","MV_PAR09","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","","",""})
aAdd(aRegs,{cPerg,"10","Cliente Final",			"","","mv_cha","C",06,0,0,"G","","MV_PAR10","",	"",		"",		"zzzzzz",		"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","","",""})
aAdd(aRegs,{cPerg,"11","Loja Inicial",			"","","mv_chb","C",02,0,0,"G","","MV_PAR11","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"12","Loja Final",			"","","mv_chc","C",02,0,0,"G","","MV_PAR12","",	"",		"",		"zz",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"13","Emissao Inicial",		"","","mv_chd","D",08,0,0,"G","","MV_PAR13","",	"",		"",		"01/01/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"14","Emissao Final",			"","","mv_che","D",08,0,0,"G","","MV_PAR14","",	"",		"",		"31/12/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"15","Vencimento Inicial",	"","","mv_chf","D",08,0,0,"G","","MV_PAR15","",	"",		"",		"01/01/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"16","Vencimento Final",		"","","mv_chg","D",08,0,0,"G","","MV_PAR16","",	"",		"",		"31/12/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"17","Natureza Inicial",		"","","mv_chh","C",10,0,0,"G","","MV_PAR17","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"18","Natureza Final",		"","","mv_chi","C",10,0,0,"G","","MV_PAR18","",	"",		"",		"zzzzzzzzzz",	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"19","Banco Cobranca",		"","","mv_chj","C",03,0,0,"G","","MV_PAR19","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","SA6",	"","","",""})
aAdd(aRegs,{cPerg,"20","Agencia Cobranca",		"","","mv_chk","C",05,0,0,"G","","MV_PAR20","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"21","Conta Cobranca",		"","","mv_chl","C",10,0,0,"G","","MV_PAR21","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"22","Sub-Conta",				"","","mv_chm","C",03,0,0,"G","","MV_PAR22","",	"",		"",		"001",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"23","Re-Impressao",			"","","mv_chn","N",01,0,0,"C","","MV_PAR23","Sim",	"Si",	"Yes",	"",				"","Nao",	"No",	"No",	"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"24","Especio Docto",			"","","mv_cho","C",03,0,0,"G","","MV_PAR24","",	"",		"",		"DM",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"25","Dia Atraso",			"","","mv_chp","N",11,2,0,"G","","MV_PAR25","",	"",		"",		"",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"26","Multa",					"","","mv_chq","N",11,2,0,"G","","MV_PAR26","",	"",		"",		"5",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"27","Dias Protesto",			"","","mv_chr","C",02,0,0,"G","","MV_PAR27","",	"",		"",		"02",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"28","Mensagem 1",			"","","mv_chs","C",40,0,0,"G","","MV_PAR28","",	"",		"",		"",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"29","Mensagem 2",			"","","mv_cht","C",40,0,0,"G","","MV_PAR29","",	"",		"",		"",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"30","Carteira",				"","","mv_chu","C",03,0,0,"G","","MV_PAR30","",	"",		"",		"109",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})


CriaSx1(aRegs)

If Pergunte (cPerg,.T.)
	
	Wnrel := SetPrint(cString,Wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,,cTamanho,,)
	
	If nLastKey == 27
		Set Filter to
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Set Filter to
		Return
	Endif
	
	// Seleciona os registros para marcação
	MsgRun( "Títulos a Receber", "Selecionando registros para processamento", { || CallRegs(@aTitulos)} )
	// Monta tela de seleção dos registros que deverão gerar o boleto
	CallTela(@aTitulos)
	
	
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CallRegs  ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os titulos conforme os parametros informados pelo  º±±
±±º          ³ usuario                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallRegs(aTitulos)

Local cQry	:= "SELECT"

cQry	+= " SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_NATUREZ,SE1.E1_CLIENTE,SE1.E1_LOJA,"
cQry	+= " SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_HIST,SE1.E1_NUMBCO,"
cQry	+= " R_E_C_N_O_ AS E1_REGSE1"
cQry	+= " FROM "+RetSqlName("SE1")+" SE1 "
cQry	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
cQry	+= " AND SE1.E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQry	+= " AND SE1.E1_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQry	+= " AND SE1.E1_PARCELA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQry	+= " AND SE1.E1_TIPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQry	+= " AND SE1.E1_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
cQry	+= " AND SE1.E1_LOJA BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
cQry	+= " AND SE1.E1_EMISSAO BETWEEN '"+DTOS(mv_par13)+"' AND '"+DTOS(mv_par14)+"'" 
cQry	+= " AND SE1.E1_VENCTO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"'"
cQry	+= " AND SE1.E1_NATUREZ BETWEEN '"+mv_par17+"' AND '"+mv_par18+"'"
cQry	+= " AND SE1.E1_SALDO > 0"
cQry	+= " AND SE1.E1_EMISNF ='1'"
cQry	+= " AND SE1.E1_PAGTO ='BO '"

If mv_par23 == 1
	cQry	+= " AND SE1.E1_NUMBCO <> ' '"
Else
	cQry	+= " AND SE1.E1_NUMBCO = ' '"
EndIf

cQry	+= " AND SE1.E1_TIPO NOT IN('"+MVABATIM+"')"
cQry	+= " AND SE1.D_E_L_E_T_ <> '*'"
cQry	+= " ORDER BY SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA"

If Select("FINR01A") > 0
	dbSelectArea("FINR01A")
	dbCloseAea()
EndIf

TCQUERY cQry NEW ALIAS "FINR01A"
TCSETFIELD("FINR01A", "E1_EMISSAO",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VENCTO",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VENCREA",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VALOR", 	"N",14,2)
TCSETFIELD("FINR01A", "E1_REGSE1",	"N",10,0)

dbSelectArea("FINR01A")
While !Eof()
	aAdd(aTitulos, {	.F.,;	// 1=Mark
	FINR01A->E1_PREFIXO,;	    // 2=Prefixo do Título
	FINR01A->E1_NUM,;		    // 3=Número do Título
	FINR01A->E1_PARCELA,;		// 4=Parcela do Título
	FINR01A->E1_TIPO,;			// 5=Tipo do Título
	FINR01A->E1_NATUREZ,;		// 6=Natureza do Título
	FINR01A->E1_CLIENTE,;		// 7=Cliente do título
	FINR01A->E1_LOJA,;			// 8=Loja do Cliente
	FINR01A->E1_NOMCLI,;	  	// 9=Nome do Cliente
	FINR01A->E1_EMISSAO,;		// 10=Data de Emissão do Título
	FINR01A->E1_VENCTO,;		// 11=Data de Vencimento do Título
	FINR01A->E1_VENCREA,;		// 12=Data de Vencimento Real do Título
	FINR01A->E1_VALOR,;			// 13=Valor do Título
	FINR01A->E1_HIST,;			// 14=Histótico do Título
	FINR01A->E1_REGSE1,;	  	// 15=Número do registro no arquivo
	FINR01A->E1_NUMBCO ;	  	// 16=Nosso Número
	})
	dbSkip()
EndDo

If Len(aTitulos) == 0
	aAdd(aTitulos, {.F.,"","","","","","","","","","","",0,"",0,""})
EndIf

dbSelectArea("FINR01A")
dbCloseArea()

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CallTela  ºAutor  ³Caio Costa          º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os titulo no objeto para o usuario selecionar os   º±±
±±º          ³ que serão impressos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallTela(aTitulos)

Local oDlg
Local oList1
Local oMark
Local bCancel   := {|| RFINR01A(oDlg,@lRetorno,aTitulos) }
Local bOk       := {|| RFINR01B(oDlg,@lRetorno,aTitulos) }
Local aAreaAtu  := GetArea()
Local aLabel	:= {" ","Prefixo","Número","Parcela","Tipo","Natureza","Cliente","Loja","Nome Cliente","Emissão","Vencimento","Venc.Real","Valor","Histórico","Nosso Número"}
Local aBotao    := {}
Local lRetorno	:= .T.
Local lMark		:= .F.
Local cList1

Private oOk		:= LoadBitMap(GetResources(),"LBOK")
Private oNo		:= LoadBitMap(GetResources(),"NADA")

AADD(aBotao, {"S4WB011N" 	, { || U__RFINR01C("SE1",SE1->(aTitulos[oList1:nAt,15]),2)}, "[F12] - Visualiza Título", "Título" })
SetKey(VK_F10,	{|| U__RFINR01C("SE1",SE1->(aTitulos[oLis1:nAt,15]),2)})


Aviso(	"Numeração Bancária",;
			"Não esquecer de verificar o número bancário antes de gerar os boletos.",;
			{"&Ok"},,;
			"A T E N Ç Ã O" )

DEFINE MSDIALOG oDlg TITLE cTitulo From 000,000 To 420,940 OF oMainWnd PIXEL
@ 015,005 CHECKBOX oMark VAR lMark PROMPT "Marca Todos" FONT oDlg:oFont PIXEL SIZE 80,09 OF oDlg;
ON CLICK (aEval(aTitulos, {|x,y| aTitulos[y,1] := lMark}), oList1:Refresh() )
@ 030,003 LISTBOX oList1 VAR cList1 Fields HEADER ;
aLabel[1],;
aLabel[2],;
aLabel[3],;
aLabel[4],;
aLabel[5],;
aLabel[6],;
aLabel[7],;
aLabel[8],;
aLabel[9],;
aLabel[10],;
aLabel[11],;
aLabel[12],;
aLabel[13],;
aLabel[14],;
aLabel[15] ;
SIZE 463,175  NOSCROLL PIXEL
oList1:SetArray(aTitulos)
oList1:bLine	:= {|| {	If(aTitulos[oList1:nAt,1], oOk, oNo),;
aTitulos[oList1:nAt,2],;
aTitulos[oList1:nAt,3],;
aTitulos[oList1:nAt,4],;
aTitulos[oList1:nAt,5],;
aTitulos[oList1:nAt,6],;
aTitulos[oList1:nAt,7],;
aTitulos[oList1:nAt,8],;
aTitulos[oList1:nAt,9],;
aTitulos[oList1:nAt,10],;
aTitulos[oList1:nAt,11],;
aTitulos[oList1:nAt,12],;
Transform(aTitulos[oList1:nAt,13], "@E 999,999,999.99"),;
aTitulos[oList1:nAt,14],;
aTitulos[oList1:nAt,16] ;
}}

oList1:blDblClick 	:= {|| aTitulos[oList1:nAt,1] := !aTitulos[oList1:nAt,1], oList1:Refresh() }
oList1:cToolTip		:= "Duplo click para marcar/desmarcar o título"
oList1:Refresh()

@ 15,81 BMPBUTTON TYPE 01 ACTION RFINR01B(oDlg,@lRetorno,aTitulos)
@ 15,110 BMPBUTTON TYPE 2 ACTION RFINR01A(oDlg,@lRetorno,aTitulos)
ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar(oDlg,bOk,bcancel,,aBotao)


SetKey(VK_F12,	Nil)

Return(lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR01A  ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Caso não seja selecionado nenhum titulo finaliza o objeto  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFINR01A(oDlg,lRetorno, aTitulos)

lRetorno := .F.

oDlg:End()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR01B  ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a quantidades de boletos que serão impressos      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFINR01B(oDlg,lRetorno, aTitulos)


Local nLoop		:= 0
Local nContador	:= 0

lRetorno := .T.

For nLoop := 1 To Len(aTitulos)
	If aTitulos[nLoop,1]
		nContador++
	EndIf
Next

If nContador > 0
	RptStatus( {|lEnd| MontaRel(aTitulos) }, cTitulo)
	
Else
	lRetorno := .F.
EndIf

oDlg:End()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOLITAU   ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _RFINR01C(cAlias, nRecAlias, nOpcEsc)

Local aAreaAtu	:= GetArea()
Local aAreaAux	:= (cAlias)->(GetArea())

If !Empty(nRecAlias)
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTo(nRecAlias)
	
	AxVisual(cAlias,nRecAlias,nOpcEsc)
EndIf

RestArea(aAreaAux)
RestArea(aAreaAtu)

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aTitulos)
LOCAL oPrint
LOCAL nX := 0
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    								       ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     					  		   ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB  	   ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)          	       ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                              	       ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          		    ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                   	        ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                 	       ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+                 ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                     	        } //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := { "Valor da Mora por Dia de Atraso de R$ "	,;   		//[1]Mora Diaria
								"Protestar após 5 dias do vencimento.."}   	    //[2]Sujeito a Protesto

LOCAL nI		:= 1
LOCAL aCB_RN_NN	:= {}
LOCAL nVlrAbat	:= 0
Local aBCOLogo  := {}
Local cDVNrBanc
Local cNrBancario
Local cAgeNN
Local cCtaNN
Local cCarNN
Local cNumNN
Local cMsg     := "Referente Nota Fiscal Eletronica Nr: "
Local cNFEle   := ""
Local cRet     := Space(30)

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() 	// ou SetLandscape()
oPrint:StartPage()   	// Inicia uma nova página

For nI:=1 To Len(aTitulos)
	
	cPrefixo := aTitulos[nI,2]
	cNum     := aTitulos[nI,3]
	cParcela := aTitulos[nI,4]
	cTipo    := aTitulos[nI,5]
	cCLiente := aTitulos[nI,7]
	cLoja    := aTitulos[nI,8]
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1") + cCliente + cLoja )
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SE1") + cPrefixo + cNum + cParcela + cTipo + cCliente + cLoja)
		Alert("O Titulo: " + cPrefixo + " " + cNum + " " + cParcela + " nao existe!")
		Loop
	Endif
	
	dbSelectArea("SA6"); dbsetOrder(1); dbseek(xFilial("SA6")+MV_PAR19)
	dbSelectArea("SEE"); dbsetOrder(1); dbseek(xFilial("SEE")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON))
	
	aDadosBanco   := {SA6->A6_COD                   			,;	    // [1] Numero do Banco
							SA6->A6_NOME      	         		,; 		// [2] Nome do Banco
							SUBSTR(SA6->A6_AGENCIA,1,4)   		,;  	// [3] Agência
							SUBSTR(SA6->A6_NUMCON,1,9)	   		,; 		// [4] Conta Corrente
							SA6->A6_DVCTA	 					,; 		// [5] Dígito da conta corrente
							SUBSTR(SEE->EE_CODEMP,1,7)	   		,;      // [9] Codigo do Cedente
							SEE->EE_CODCART 					,;      // [6] Codigo da Carteira
							SA6->A6_TXMLTBL						,;	    // [7] Tx da Multa
							SA6->A6_TXMORBL 					 }      // [8] Tx de Mora Diaria
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := { AllTrim(SA1->A1_NOME)          						 ,;     	// [1]Razao Social
								AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     	// [2]Codigo
								AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;    		// [3]Endereço
								AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
								SA1->A1_EST                                      ,;   		// [5]Estado
								SA1->A1_CEP                                      ,;     	// [6]CEP
								SA1->A1_CGC										 ,;  		// [7]CGC
								SA1->A1_PESSOA}       										// [8]PESSOA
	Else
		aDatSacado   := { AllTrim(SA1->A1_NOME)            	  							,;   	// [1]Razão Social
								AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA             		,;   	// [2]Código
								AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC)	,;   	// [3]Endereço
								AllTrim(SA1->A1_MUNC)	                            	,;   	// [4]Cidade
								SA1->A1_ESTC	                                   	   	,;   	// [5]Estado
								SA1->A1_CEPC                                          	,;   	// [6]CEP
								SA1->A1_CGC												,;		// [7]CGC
								SA1->A1_PESSOA}										          	// [8]PESSOA
	Endif
	
	//--- 22.03.07
	//If Empty (SE1->E1_NUMBCO)
	//   U_GeraNNBol()
	//EndIf
	If Empty(SE1->E1_PORTADOR)
		RecLock( "SE1" , .F. )
		SE1->E1_PORTADOR := SA6->A6_COD
		MsUnlock()
	EndIf
	If Empty (SE1->E1_NUMBCO)
		cNumNN   := Strzero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
		
		RecLock( "SEE" , .F. )
		SEE->EE_FAXATU := cNumNN
		MsUnlock()
		
		//--- Para o Santander precisa gravar o Nosso Numero com o Digito (Modulo 11)
		nCalcNrBanc  := Alltrim(cNumNN)
		cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
		cNossoNum 	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
		
		RecLock( "SE1" , .F. )
		SE1->E1_NUMBCO := cNossoNum
		SE1->E1_NOMEUSE  := CUSERNAME                       // NOME DO USUARIO QUE GEROU O BOLETO
		SE1->E1_BKPNNUM  := SE1->E1_NUMBCO  	            // BACKUP DO NOSSO NUMERO
		SE1->E1_BKPPORT  := ALLTRIM(MV_PAR19)               // BANCO SELECIONADO NOS PARAMETROS
		SE1->E1_BKPAGEN  := ALLTRIM(MV_PAR20)               // AGENCIA SELECIONADA NOS PARAMETROS
		SE1->E1_BKPCONT  := ALLTRIM(MV_PAR21)               // CONTA SELECIONADA NOS PARAMETROS
		SE1->E1_DATABO   := dDataBase                 // DATA DA GERACAO DO BOLETO
		SE1->E1_HORABO   := TIME()                          // HORA DA GERACAO DO BOLETO
		MsUnlock()
	Else
		cNossoNum := Substr(SE1->E1_NUMBCO,1,12)
	EndIf
	//--- fim 22.03.07
	
	cAgeNN		:= SUBSTR(SA6->A6_AGENCIA,1,4)
	cCtaNN		:= SUBSTR(SA6->A6_NUMCON,1,9)
	cCarNN		:= SEE->EE_CODCART
	cNumNN		:= SUBSTR(SE1->E1_NUMBCO,1,12)
	nCalcNrBanc := Alltrim(cNumNN)
	cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
	cNrBancario	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
	nVlrAbat    :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	//Monta codigo de barras
	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNrBancario,(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO,cCarNN,aDadosBanco[6])
	
	
	aDadosTit := { AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)   				,;  // [1] Número do título e parcela
						SE1->E1_EMISSAO                    		  		   		,;  // [2] Data da emissão do título
						dDataBase                    			 				,;  // [3] Data da emissão do boleto
						SE1->E1_VENCTO                     		 		   		,;  // [4] Data do vencimento
						(SE1->E1_SALDO - nVlrAbat)         		 		  		,;  // [5] Valor do título
						SE1->E1_NUMBCO							 				,;  // [6] Nosso número (Ver fórmula para calculo)
						SE1->E1_PREFIXO                    	 					,;  // [7] Prefixo da NF
						SE1->E1_TIPO	                       				 	,;  // [8] Tipo do Titulo
						SE1->E1_OBSBOL	                       				 	}   // [9] Observacao Boleto	

	If !Empty(SE1->E1_NFELETR)
		cRet := cMsg + SE1->E1_NFELETR
	Endif
	
	Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNrBancario,cRet,cDVNrBanc,cCarNN)
	nX := nX + 1
	
	IncProc()
Next nI

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNrBancario,cRet,cDVNrBanc,cCart)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont13
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
Local cLogoSant := '\system\santander.bmp'
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

nRow2 := 10

///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
//PRIMEIRA PARTE - COMPROVANTE DE ENTREGA

oPrint:Line(nRow2+0150,500,nRow2+0070, 500)
oPrint:Line(nRow2+0150,710,nRow2+0070, 710)

oPrint:SayBitmap(nRow2+0050,100,cLogoSant,400,100) //300, 120       // Imprime o Logo do Banco     +0135
oPrint:Say(nRow2+0075,513,aDadosBanco[1]+"-7",oFont21 )				// [1]Numero do Banco

oPrint:Say(nRow2+0084,1800,"Comprovante de Entrega",oFont10)
oPrint:Line(nRow2+0150,100,nRow2+0150,2300)

oPrint:Say(nRow2+0150,100 ,"Beneficiario",oFont8)
oPrint:Say(nRow2+0165,320 ,"",oFont8)
oPrint:Say(nRow2+0205,100 ,aDadosEmp[1],oFont8) //Nome + CNPJ

oPrint:Say(nRow2+0150,1060,"Agência/Código do Cedente",oFont8)
oPrint:Say(nRow2+0200,1060,aDadosBanco[3]+" / "+SubStr(aCB_RN_NN[2],7,4)+SubStr(aCB_RN_NN[2],15,3),oFont10)       //aDadosBanco[4])


oPrint:Say(nRow2+0150,1510,"Nro.Documento",oFont8)
oPrint:Say(nRow2+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo+Numero+Parcela

oPrint:Say(nRow2+0250,100 ,"Pagador",oFont8)
oPrint:Say(nRow2+0300,100 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"            ,oFont8) //Nome

oPrint:Say(nRow2+0250,1060,"Vencimento",oFont8)
oPrint:Say(nRow2+0300,1080,StrZero(Day(aDadosTit[4]),2)+"/"+StrZero(Month(aDadosTit[4]),2)+"/"+Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say(nRow2+0250,1510,"Valor do Documento",oFont8)
oPrint:Say(nRow2+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say(nRow2+0400,0100,"Recebi(emos)o boleto/título com as caracteristicas acima.",oFont8)
oPrint:Say(nRow2+0350,1060,"Data",oFont8)
oPrint:Say(nRow2+0350,1410,"Nome",oFont8)
oPrint:Say(nRow2+0450,1060,"RG",oFont8)
oPrint:Say(nRow2+0450,1410,"Assinatura",oFont8)

oPrint:Line(nRow2+0250, 100,nRow2+0250,1900 )
oPrint:Line(nRow2+0350, 100,nRow2+0350,1900 )
oPrint:Line(nRow2+0450,1050,nRow2+0450,1900 )
oPrint:Line(nRow2+0550, 100,nRow2+0550,2300 )

oPrint:Line(nRow2+0550,1050,nRow2+0150,1050 )
oPrint:Line(nRow2+0550,1400,nRow2+0350,1400 )
oPrint:Line(nRow2+0350,1500,nRow2+0150,1500 )
oPrint:Line(nRow2+0550,1900,nRow2+0150,1900 )

oPrint:Say(nRow2+0165,1910,"(  )Mudou-se"                ,oFont8)
oPrint:Say(nRow2+0205,1910,"(  )Ausente"                 ,oFont8)
oPrint:Say(nRow2+0245,1910,"(  )Não existe nº indicado"  ,oFont8)
oPrint:Say(nRow2+0285,1910,"(  )Recusado"                ,oFont8)
oPrint:Say(nRow2+0325,1910,"(  )Não procurado"           ,oFont8)
oPrint:Say(nRow2+0365,1910,"(  )Endereço insuficiente"   ,oFont8)
oPrint:Say(nRow2+0405,1910,"(  )Desconhecido"            ,oFont8)
oPrint:Say(nRow2+0445,1910,"(  )Falecido"                ,oFont8)
oPrint:Say(nRow2+0485,1910,"(  )Outros(anotar no verso)" ,oFont8)


///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
//SEGUNDA PARTE - RECIBO DE ENTREGA

          
nRow2 := 0600

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

oPrint      :SayBitmap(nRow2+0100,100,cLogoSant,400,100) //300, 120  	    // Imprime o Logo do Banco     +0135
oPrint:Say  (nRow2+0135,513,aDadosBanco[1]+"-7",oFont21 )			// [1]Numero do Banco
oPrint:Say  (nRow2+0144,1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2+0310,100,nRow2+0310,2300 )
oPrint:Line (nRow2+0410,100,nRow2+0410,2300 )
oPrint:Line (nRow2+0480,100,nRow2+0480,2300 )
oPrint:Line (nRow2+0550,100,nRow2+0550,2300 )

oPrint:Line (nRow2+0410,500,nRow2+0550,500)
oPrint:Line (nRow2+0480,750,nRow2+0550,750)
oPrint:Line (nRow2+0410,1000,nRow2+0550,1000)
oPrint:Line (nRow2+0410,1300,nRow2+0480,1300)
oPrint:Line (nRow2+0410,1480,nRow2+0550,1480)

oPrint:Say  (nRow2+0210,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0225,400 ,"Pagar preferencialmente no Santander",oFont10)

oPrint:Say  (nRow2+0210,1810,"Vencimento"                                     ,oFont8)
cString	    :=StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol        :=1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0310,100 ,"Beneficário"                                        ,oFont8)
oPrint:Say  (nRow2+0350,100 ,aDadosEmp[1]+"       - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0310,1810,"Agência/Código Cedente",oFont8)
cString     :=Alltrim(aDadosBanco[3]+" / "+SubStr(aCB_RN_NN[2],7,4)+SubStr(aCB_RN_NN[2],15,3))       //aDadosBanco[4])
nCol        :=1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0350,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0410,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0440,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0410,505 ,"Número do Documento"                      ,oFont8)
oPrint:Say  (nRow2+0440,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0410,1005,"Espécie Documento"                                   ,oFont8)
oPrint:Say  (nRow2+0440,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0410,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0440,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0410,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0440,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0410,1810,"Nosso Número"                                   ,oFont8)
cString     := Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + Alltrim(str(cDVNrBanc)) )
nCol        := 1810+(444-(len(cString)*22))
oPrint:Say  (nRow2+0440,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0480,100 ,"Carteira    "                                   ,oFont8)
oPrint:Say  (nRow2+0510,105 ,cCart                                            ,oFont10)

oPrint:Say  (nRow2+0480,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+0510,805 ,"REAL"                                             ,oFont10)

oPrint:Say  (nRow2+0480,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0480,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0480,1810,"(=) Valor do Documento"                          	,oFont8)
cString     := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol        := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0510,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+0550,100 ,"Instruções (Termo de responsabilidade do cedente)",oFont8)

oPrint:Say  (nRow2+0600,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(4.50/30))/100),"@E 99,999.99"))        ,oFont10)
oPrint:Say  (nRow2+0650,100 ,aBolText[2]                                                                        	,oFont10)
oPrint:Say  (nRow2+0700,100 ,SubStr(aDadosTit[9],1,77)																,oFont10) 	
oPrint:Say  (nRow2+0750,100 ,SubStr(aDadosTit[9],78,77)																,oFont10)
oPrint:Say  (nRow2+0800,100 ,cRet																					,oFont10)

oPrint:Say  (nRow2+0550,1810,"(-)Desconto"                         		   ,oFont8)
oPrint:Say  (nRow2+0620,1810,"(-)Abatimento"                               ,oFont8)
oPrint:Say  (nRow2+0690,1810,"(+)Mora"                                     ,oFont8)
oPrint:Say  (nRow2+0760,1810,"(+)Outros Acréscimos"                        ,oFont8)
oPrint:Say  (nRow2+0830,1810,"(=)Valor Cobrado"                            ,oFont8)

oPrint:Say  (nRow2+0900,100 ,"Pagador"                                     				,oFont8)
oPrint:Say  (nRow2+0910,400 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"         				,oFont10)			  // Nome
oPrint:Say  (nRow2+0970,400 ,aDatSacado[3]                                 				,oFont10)    		  // Endereço
oPrint:Say  (nRow2+1030,400 ,aDatSacado[4]+" - "+aDatSacado[5]+ " CEP: " + aDatSacado[6],oFont10) 			  // Cidade+Estado+CEP
if aDatSacado[8] = "F"
	oPrint:Say  (nRow2+1090,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 			      // CPF
Else
	oPrint:Say  (nRow2+1090,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) 		  // CGC
EndIf

oPrint:Say  (nRow2+1145,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1145,1500,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0210,1800,nRow2+0900,1800 )
oPrint:Line (nRow2+0620,1800,nRow2+0620,2300 )
oPrint:Line (nRow2+0690,1800,nRow2+0690,2300 )
oPrint:Line (nRow2+0760,1800,nRow2+0760,2300 )
oPrint:Line (nRow2+0830,1800,nRow2+0830,2300 )
oPrint:Line (nRow2+0900,100 ,nRow2+0900,2300 )
oPrint:Line (nRow2+1140,100 ,nRow2+1140,2300 )

///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
///\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
//TERCEIRA PARTE - PARTE DO CODIGO DE BARRA


nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30) //1380 anterior
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

oPrint:SayBitmap(nRow3+1900,100,cLogoSant,400,100) //300, 120      // Imprime o Logo do Banco
oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )		   // [1]Numero do Banco
oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont14n)			       // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2015,400 ,"Pagar preferencialmente no Santander",oFont10)

oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString 	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	    := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)     

oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"       - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
cString 	:= Alltrim(aDadosBanco[3]+" / "+SubStr(aCB_RN_NN[2],7,4)+SubStr(aCB_RN_NN[2],15,3))       //aDadosBanco[4])
nCol 	 	:= 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              										,oFont8)
oPrint:Say 	(nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+2200,505 ,"Número do Documento"                                  								,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]					   											,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Espécie Documento"                                   									,oFont8)
oPrint:Say  (nRow3+2230,1050,"DM"																					,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite"                                         										,oFont8)
oPrint:Say  (nRow3+2230,1400,"N"                                             										,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          										,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   										,oFont8)
cString 	:=Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + Alltrim(str(cDVNrBanc))  )
nCol		:=1810+(444-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2270,100 ,"Carteira"                                 	  										,oFont8)
oPrint:Say  (nRow3+2300,105 ,cCart                        					  										,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        										,oFont8)
oPrint:Say  (nRow3+2300,805 ,"REAL"                                           										,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     										,oFont8)
oPrint:Say  (nRow3+2300,1485,"Valor"                                          										,oFont8)

oPrint:Say  (nRow3+2270,1810,"(=) Valor do Documento"                         										,oFont8)
cString		:=Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol		:=1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instruções (Termo de responsabilidade do cedente)"									,oFont8)

oPrint:Say  (nRow3+2390,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(4.50/30))/100),"@E 99,999.99"))        ,oFont10)
oPrint:Say  (nRow3+2440,100 ,aBolText[2]                                                                        	,oFont10)
oPrint:Say  (nRow3+2490,100 ,SubStr(aDadosTit[9],1,77)																,oFont10) 	
oPrint:Say  (nRow3+2540,100 ,SubStr(aDadosTit[9],78,77)																,oFont10)
oPrint:Say  (nRow3+2640,100 ,cRet																					,oFont10)  

oPrint:Say  (nRow3+2340,1810,"(-)Desconto"                          								,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Abatimento"                        								,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora"                              								,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"         										,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"               										,oFont8)

oPrint:Say  (nRow3+2690,100 ,"Pagador"                                         						,oFont8)
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"            						,oFont10)
oPrint:Say  (nRow3+2750,400 ,aDatSacado[3]                                     						,oFont10)
oPrint:Say  (nRow3+2800,400 ,aDatSacado[4]+" - "+aDatSacado[5]+ " CEP: " + aDatSacado[6]			,oFont10) // Cidade+Estado+CEP

if aDatSacado[8] = "F"
	oPrint:Say  (nRow3+2850,400,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99")				,oFont10) // CPF
Else
	oPrint:Say  (nRoàw3+2850,400,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")			,oFont10) // CGC
EndIf
oPrint:Say  (nRow3+2910,100 ,"Sacador/Avalista"                              		    	        ,oFont8)
oPrint:Say  (nRow3+2910,1500,"Autenticação Mecânica - Ficha de Compensação"                         ,oFont8)


oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
oPrint:Line (nRow3+2900,100 ,nRow3+2900,2300 )

MSBAR("INT25",25.9,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
  

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Modulo11Nn³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11Nn(cData)
LOCAL L, D, P,R := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

R := mod(D,11)
If (R == 10)
	D := 1
ElseIf (R == 0 .or. R == 1)
	D := 0
Else
	D := (11 - R)
End

Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNrBancario,nValor,dVencto,cCart,cCedente)

LOCAL cValorFinal 	:= strzero(nValor*100,10)
LOCAL nDvnn		  	:= 0
LOCAL nDvcb		 	:= 0
LOCAL nDv		 	:= 0
LOCAL cNN		  	:= ''
LOCAL cRN		  	:= ''
LOCAL cCB		  	:= ''
LOCAL cS			:= ''
LOCAL cFator     	:= strzero(dVencto - ctod("07/10/97"),4)

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
// cBanco está igual a 0339
cS		:= cBanco + cFator +  cValorFinal + "9" + cCedente + cNrBancario + "0" + cCart
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.DDDDX		EEEFF.FFFFFY	GGGGG.GHJJJZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	  C = Fixo "9"
//	 DDDD = 4 Primeiras posicoes do codigo do cedente padrao Santander Banespa
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS1   := cBanco + "9" + SubStr(cCedente,1,4)
nDv1  := modulo10(cS1)
cRN1  := SubStr(cS1, 1, 5) + '.' + SubStr(cS1, 6, 4) + AllTrim(Str(nDv1)) + '   '

// 	CAMPO 2:
//	EEE  = Restante do Codigo do Cedente padrao Santander Banesp
//	FFFFFFF = Sete primeiros campos do Nosso Numero
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS2 := SubStr(cCedente,5,3) + SubStr(cNrBancario,1,7)
nDv2:= modulo10(cS2)
cRN2:= SubStr(cS2, 1, 5) + '.' + SubStr(cS2, 6, 5) + AllTrim(Str(nDv2)) + '   '

// 	CAMPO 3:
//	GGGGGG = Restante do Nosso Numero
//	H              = 0  (Conteudo Fixo)
//	JJJ            = Carteira
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS3   := Subs(cNrBancario,8,6) + "0" + cCart
nDv3  := modulo10(cS3)
cRN3  := SubStr(cS3, 1, 5) + '.' + SubStr(cS3, 6, 5) + AllTrim(Str(nDv3)) + '   '

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN4  := AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN5  := cFator + cValorFinal

cRN	  := cRN1 + cRN2 + cRN3 + cRN4 + cRN5

Return({cCB,cRN})



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 23.05.05 ³ Modelagem de Dados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)