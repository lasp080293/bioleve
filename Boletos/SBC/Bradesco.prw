#include "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±³Fun‡…o    ³ BOLBRD   ³ Autor ³ Peterson               ³ Data ³ 12.07.04 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±³Descri‡…o ³ Programa de Impressao de BOLETOS c/ Codigo de Barras        ³±±
±±³            para o BRADESCO                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN   parametro MV_APTNSNU                              ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Alterado por Gilberto Kuhn em   15/07/04
alterado por Silvio César Alpi  04/01/05
alterado por Silvio César Alpi  23/11/05    // Colocação da parcela do Titulo na Impressão e Perguntas
alterado por Alexandre L.Santos 28/11/18
/*/


User Function Bradesco(Danfe,nString)
oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )

#define DS_MODALFRAME   128
DEFINE MsDialog oDlg1 From 0,0 To 350,300 Title "EMISSÃO DE BOLETOS" Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.
//oDlg1:lTEscClose := .F.

oSay1      := TSay():New( 05,25,{||"EMISSÃO DE BOLETOS"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oSay1      := TSay():New( 20,45,{||"      BANCO       "},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oTBitmap1  := TBitmap():New(50,35,150,150,,"LOGO_BRADESCO.PNG",.T.,oDlg1,,,.F.,.F.,,,.F.,,.T.,,.F.)

oBtn1      := TButton():New( 150,025,"OK",oDlg1,{|| OK()},035,015,,oFont2,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 150,100,"Cancelar",oDlg1,{|| oDlg1:End()},035,015,,oFont2,,.T.,,"",,,,.F. )

ACTIVATE DIALOG oDlg1 CENTERED
Return(.T.)


Static Function OK(Danfe,nString)

SetPrvt("AAC,ACRA,CNOMEREL,CFILE,CSAVSCR1,CSAVCUR1")
SetPrvt("CSAVROW1,CSAVCOL1,CSAVCOR1,ANOTA,CALIAS,CSAVSCR3")
SetPrvt("CCOLOR,n_vias")
SetPrvt("CTELA,AFILE,CSAVSCR,I,CSAVCOR,NOPCFILE")
SetPrvt("NOPCA,NTREGS,NMULT,NANT,NATU,NCNT")
SetPrvt("NTOTPORCEN,CSAV20,CSAV7,NDIA,CBARRA,CLINHA,cBarraImp,cBarraFim,cPrintBanc,cPrUsoBc")
SetPrvt("NDIGITO,CCAMPO,NCONT,NVAL,instr1,instr2,cBarraImp4,X,NOSSONUM,nCpoLivre,MsnLocPg,MsnLocPg2,cAgenciaCedente")
Private nLastKey     	:= 0
Private cPerguntas   	:= .F.
Private oFont, cCode
Private cBarraFim
Private njuros			:= 0
Private nmulta			:= 0
Private nvalliq			:= 0
cBarraImp 				:= space(50)
nHeight					:= 15
lBold					:= .F.
lUnderLine				:= .F.
lPixel					:= .T.
lPrint					:= .F.
nSedex 					:= 1
MsgInstr01				:= " "
MsgInstr02 				:= " "
MsgInstr03 				:= " "
MsgInstr04				:= 0.000
n_vias 					:= " "
cPerg 					:= "BRAD      "

Close(oDlg1)

IF Empty(nString)
	ValidPerg()
	//Parametros()//GERA PARAMETROS
	if Pergunte(cPerg,.t.)//CONFIRMACAO DOS PARAMETROS
		Processa( {|| GERADADOS(@Danfe,nString)},"Gerando Boleto ", "Aguarde") 			//PROCESSAMENTO DOS CALCULOS
	endif
Else
	Processa( {|| GERADADOS(@Danfe,nString)},"Gerando Boleto "•+nString, "Aguarde") //PROCESSAMENTO DOS CALCULOS
EndIF

return


//-----------------------------------------------------------------------------
Static Function ValidPerg()
// Objetivo: Criar as perguntas necessarias ao relatorios, caso nao existam
//-----------------------------------------------------------------------------
Local aRegs := {}, i, j, aAreaSX1 := SX1->(GetArea())
SX1->(dbSetOrder(1))
AADD(aRegs,{cPerg,"01","Prefixo De         ?","","","mv_ch1" ,"C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Prefixo Ate        ?","","","mv_ch2" ,"C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do titulo          ?","","","mv_ch3" ,"C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate titulo         ?","","","mv_ch4" ,"C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Parcela         ?","","","mv_ch5" ,"C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate à Parcela      ?","","","mv_ch6" ,"C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Banco              ?","","","mv_ch7" ,"C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
AADD(aRegs,{cPerg,"08","Agencia            ?","","","mv_ch8" ,"C",05,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Conta              ?","","","mv_ch9" ,"C",07,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i := 1 To Len(aRegs)
	if ! SX1->(dbSeek(cPerg+aRegs[i,2]))
		RecLock("SX1", .T.)
		For j := 1 to SX1->(FCount())
			If j <= Len(aRegs[i])
				SX1->(FieldPut(j,aRegs[i,j]))
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next
SX1->(RestArea(aAreaSX1))
Return


Static Function GERADADOS(oPrn,nString)
local cNewValor := ""
local nZeros    := 0
local i
local cValor

//cQuery+= " E1_PAGTO $ 'BO /SBO'  AND E1_EMISNF = '2' AND "  //EMISSAO NF LINDOIA
//cQuery+= " ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA"
//cQuery+= " E1_EMISNF = '2'"
//cQuery+= " E1_PAGTO = 'BO '"
//cQuery+= " ORDER BY E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA"



//Verificando se o Alias não está ativo
IF Select("TbBol") > 0
	DbSelectArea("TbBol")
	TbBol->(DbCloseArea())
Endif
//Query para selecionar o dados
cQuery := "SELECT E1_CLIENTE,E1_EMISSAO,E1_VALJUR,E1_FILIAL,E1_PARCELA,E1_NUMBCO,E1_NUMBOR,"
cQuery+= " A1_CGC, A1_END,A1_COMPLEM,A1_CEP,A1_BAIRRO,A1_MUN,A1_EST,A1_NOME,A1_END, A1_MUN, A1_BAIRRO,A1_EST,A1_CEP,"
cQuery+= " E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_VENCTO, E1_VENCREA, E1_NUM, E1_PREFIXO, E1_VALOR, E1_SALDO, SE1.R_E_C_N_O_ AS SE1RECNO "//, EA_UNCART"
cQuery+= " FROM "+RetSqlName("SE1") + " SE1, "+RetSqlName("SA1") + " SA1, "+RetSqlName("SC5") + " SC5 "
cQuery+= " WHERE SA1.D_E_L_E_T_ = '' "
cQuery+= " AND SE1.D_E_L_E_T_= '' "
cQuery+= " AND SC5.D_E_L_E_T_= '' "
cQuery+= " AND E1_CLIENTE = A1_COD "
cQuery+= " AND E1_LOJA = A1_LOJA "
cQuery+= " AND E1_PREFIXO >= '"+mv_par01+"' AND E1_PREFIXO <= '"+mv_par02+"'"
cQuery+= " AND E1_NUM >='"+mv_par03+"' AND "
cQuery+= " E1_NUM <='"+mv_par04+"' AND"
cQuery+= " E1_PARCELA >='"+mv_par05+"' AND"
cQuery+= " E1_PARCELA <='"+mv_par06+"' AND "
cQuery+= " E1_PEDIDO = C5_NUM AND "
cQuery+= " E1_EMISNF = '2' AND "
cQuery+= " E1_PAGTO = 'BO '"
cQuery+= " ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA"


//cQuery+= " ORDER BY E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA"


TCQUERY cQuery NEW ALIAS "TbBol"
TCSetField("TbBol","E1_EMISSAO","D")
TCSetField("TbBol","E1_VENCTO","D")
//TCSetField("TbBol","E1_UDTPROC","D")

DbSelectArea("TbBol")
ProcRegua(TbBol->(RecCount()))
TbBol->(dbgotop())

IF !Eof()
	//MONTA INTERFACE COM USUÁRIO
	IF Empty(nString)
		oPrn := TMSPrinter():New( "Boleto Bradesco" )
		oPrn:SetPaperSize(9) //A4
		oPrn:SetPortrait()
	EndIf

	//FONTES A SEREM UTILIZADAS
	oFont1 := TFont():New( "Times New Roman",,07,,.t.,,,,,.f. )
	oFont2 := TFont():New( "Times New Roman",,09,,.t.,,,,,.f. )
	oFont3 := TFont():New( "Times New Roman",,11,,.t.,,,,,.f. )
	oFont4 := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont5 := TFont():New( "Times New Roman",,15,,.t.,,,,,.f. )
	oFont6 := TFont():New( "HAETTENSCHWEILLER",,09,,.t.,,,,,.f. )
	oFont8 := TFont():New( "Free 3 of 9"   ,,43,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9"   ,,37,,.t.,,,,,.f. )
	oFont11:= TFont():New( "Courier New"   ,,09,,.t.,,,,,.f. )
	oFont12:= TFont():New( "Courier New"   ,,08,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Arial"         ,,05,,.f.,,,,,.f. )
	oFont14:= TFont():New( "Arial"         ,,08,,.F.,,,,,.f. )
	oFont15:= TFont():New( "Arial"         ,,08,,.t.,,,,,.f. )
	oFont16:= TFont():New( "Arial"         ,,09,,.f.,,,,,.f. )
	oFont17:= TFont():New( "Arial"         ,,13,,.T.,,,,,.f. )
	oFont18:= TFont():New( "Arial"         ,,08,,.T.,,,,,.f. )
	oFont19:= TFont():New( "Arial"         ,,21,,.t.,,,,,.f. )
	oFont20:= TFont():New( "Arial Black"   ,,15,,.t.,,,,,.f. )
	oFont21:= TFont():New( "Arial"         ,,17,,.t.,,,,,.f. )
	oFont22:= TFont():New( "Arial"         ,,12,,.t.,,,,,.f. )
	oFont23:= TFont():New( "Arial Black"   ,,14.7,,.t.,,,,,.f. )
	oFont24:= TFont():New( "Courier New" ,,07,,.t.,,,,,.f. )
EndIF


While !TbBol->(Eof())
	IncProc()//INCREMENTA A REGUA
	cCartei :='2'       //Posicione("SEA",2,xFilial("SEA")+TbBol->E1_NUMBOR+"R"+TbBol->E1_PREFIXO+TbBol->E1_NUM+TbBol->E1_PARCELA,"EA_UNCART")

	cCartei := ALLTRIM(STR(VAL(cCartei)))
	If Alltrim(cCartei) == "0" //Verificando se existe carteira
		MsgBox("O boleto do título:  "+TbBol->E1_PREFIXO+" "+TbBol->E1_NUM+ IIF(!EMPTY(TbBol->E1_PARCELA),'/'+TbBol->E1_PARCELA,' ')+chr(13)+chr(10)+"Não contém nº de carteira. Verifique com o T.I.","Borderô do Título sem Nº de carteira!","STOP")
		TbBol->(dbSkip())
		Loop
	EndIF

	SE1->(dbGoTo(TbBol->SE1RECNO))

	SEE->(DbSetOrder(1))
	SEE->(DbSeek( xFilial("SEE") + MV_PAR07 + MV_PAR08 + MV_PAR09 ),.T.)

	If Empty(SE1->E1_NUMBCO) 	//SE FOR GERADO A PRIMEIRA VEZ
		cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,11)
		RecLock("SEE",.f.)
		SEE->EE_FAXATU := cNossoNum
		SEE->(dbUnlock())
		cNossoNum := 	DigVerfNSNum( Alltrim(SEE->EE_CODIGO)	,;
		Alltrim(SEE->EE_AGENCIA)				,;
		Alltrim(SEE->EE_CONTA)					,;
		STRZERO(VAL(cCartei),2)			,;
		ALLTRIM(cNossoNum) )
		RecLock("SE1",.f.)
		SE1->E1_NUMBCO := cNossoNum
		SE1->E1_NOMEUSE  := CUSERNAME                       // NOME DO USUARIO QUE GEROU O BOLETO
		SE1->E1_BKPNNUM  := SE1->E1_NUMBCO  	            // BACKUP DO NOSSO NUMERO
		SE1->E1_BKPPORT  := ALLTRIM(MV_PAR07)               // BANCO SELECIONADO NOS PARAMETROS
		SE1->E1_BKPAGEN  := ALLTRIM(MV_PAR08)               // AGENCIA SELECIONADA NOS PARAMETROS
		SE1->E1_BKPCONT  := ALLTRIM(MV_PAR09)               // CONTA SELECIONADA NOS PARAMETROS
		SE1->E1_DATABO   := dDataBase                 // DATA DA GERACAO DO BOLETO
		SE1->E1_HORABO   := TIME()                          // HORA DA GERACAO DO BOLETO
		SE1->(MsUnlock())
	Else 						//ESTA GERANDO NOVAMENTE
		cNossoNum := Substr(SE1->E1_NUMBCO,1,12)
	Endif

	If len(Alltrim(cNossoNum)) < 12 //Verificando o nosso Número
		MsgBox("O boleto do título:  "+TbBol->E1_PREFIXO+" "+TbBol->E1_NUM+ IIF(!EMPTY(TbBol->E1_PARCELA),'/'+TbBol->E1_PARCELA,' ')+chr(13)+chr(10)+"Não contém 12 dígito no nosso número. Verifique com o T.I.","Título com problemas no nosso número!","STOP")
		TbBol->(dbSkip())
		Loop
	EndIF

	nDataBase 	:= 	CtoD("07/10/1997") // data base para calculo do fator
	//cFatorVen	:= 	Alltrim(Str(TbBol->E1_VENCREA - nDataBase)) // acha a diferenca em dias para o fator de vencimento
	cFatorVen	:= 	Alltrim(Str(TbBol->E1_VENCTO - nDataBase)) // acha a diferenca em dias para o fator de vencimento
	cBancoM 	:= 	SUBS(SEE->EE_CODIGO,1,3)
	cAgenci 	:= 	SUBS(SEE->EE_AGENCIA,1,5)
	cDigAgenci 	:= 	SUBS(SEE->EE_DVAGE,1,1)
	cContac 	:= 	SUBS(SEE->EE_CONTA,1,7)
	cDigContac 	:= 	SUBS(SEE->EE_DVCTA,1,1)
	cNome 		:= 	TbBol->A1_NOME
	obsbol      :=  se1->e1_obsbol

	//calcula o juro ao dia
	njuros 		:=  ROUND( (u_VrLiQSE1()*0.15) / 100 ,2)
	nmulta 		:=  ROUND( (u_VrLiQSE1()*0.02) ,2)
	nvalliq		:=  u_VrLiQSE1()
	cValor	 	:=  STRZERO(nvalliq,14,2)

	cNewValor 	:= ""
	nZeros    	:= 0
	for i:=1 to len(cValor)
		if Substr(cValor,i,1) # "." .and. Substr(cValor,i,1) # ","
			cNewValor += Substr(cValor,i,1)
		ELSE
			nZeros ++
		endif
	next
	cValor := ""
	For i:=1 to nZeros
		cValor += "0"
	next
	cValor += Substr(Alltrim(cNewValor),5,10)

	cVctoRea  := Dtos(TbBol->E1_VENCTO)
	cNumDig10 := space(10)
	cDigVerif := "0"


	//	Campo livre (cada banco defini o seu) da posição 20 a 44 do codigo de barras
	IF cBancoM =="237"  // Bradesco
		MsgInstr02 		:="Protestar após 5 dias corridos do vencimento"
		MsgInstr03 		:= obsbol
		cCartei 		:= STRZERO(VAL(cCartei),2)
		nCpoLivre 		:= SUBSTR(STRZERO(Val(cAgenci),5),2,4) + cCartei + Substr(cNossoNum,1,11) + SUBSTR(STRZERO(Val(cContac),7),1,7)+"0"
		cAgenciaCedente	:= SUBSTR(cAgenci,1,4)+"-"+cDigAgenci+"/"+cContac+"-"+cDigContac
		cUBANBitMap		:= GetSrvProfString('Startpath','') + 'logobradesco.jpg'
		cPrintBanc 		:="237-2"
		cPrUsoBc 		:="               000"
		//       cDigVerif := NosNumBRD()//CaLculo modulo 11, RETORNA O DIGITO VERIF.
		cNossoNum 		:= cCartei+cNossoNum//+cDigVerif //CARTEIRA + NOSSO NUMERO
		cNossonum 		:= Substr(cNossoNum,1,2)+"/"+Substr(cNossoNum,3,11)+"-"+Substr(cNossoNum,14,+len(cNossoNum))
		MsnLocPg 		:="ATÉ O VENCIMENTO, PREFERENCIALMENTE NO BRADESCO"
		MsnLocPg2		:="APÓS O VENCIMENTO, SOMENTE NO BRADESCO"

	EndIF
	//---------------> CALCULO DOS GRUPOS PARA O IPTE

	//CALCULO DIGITO 1o GRUPO
	cNumDig10 := cBancoM+"9"+Substr(nCpoLivre,1,5) //JU
	cDigVerif := CalcDigMOD10(cNumDig10)//Calculo modulo 10, RETORNA O DIGITO VERIF.
	cPriGrupo := cNumDig10 + cDigVerif //RETORNA 10 POSICOES

	//CALCULO DIGITO 2o GRUPO           //04472
	cNumDig10 := Substr(nCpoLivre,6,10)
	cDigVerif := CalcDigMOD10(cNumDig10)//Claculo modulo 10, RETORNA O DIGITO VERIF.
	cSegGrupo := cNumDig10 + cDigVerif //RETORNA 11 POSICOES

	//CALCULO DIGITO 3o GRUPO
	cNumDig10 := Substr(nCpoLivre,16,10)
	cDigVerif := CalcDigMOD10(cNumDig10)//Claculo modulo 10, RETORNA O DIGITO VERIF.
	cTerGrupo := cNumDig10+cDigVerif

	//----> DIGITO VERIF. DO COD BARRAS
	cNumDig10 := cBancoM + "9" + cFatorVen + cValor + nCpoLivre
	lCodBarr := .t.
	cDigVerif := CalcDigM11()//Claculo modulo 11, RETORNA O DIGITO VERIF.
	cQuaGrupo := cDigVerif

	//---->MONTAGEM DO LAYOUT DA LINHA DIGITAVEL
	cLinhaDig := cPriGrupo + cSegGrupo + cTerGrupo + cQuaGrupo + cFatorVen + cValor
	cLinhaDigImp := substr(cLinhaDig,1,4)+substr(cLinhaDig,5,1)+"."+substr(cLinhaDig,6,5)+" "+;
	substr(cLinhaDig,11,5)+"."+;
	substr(cLinhaDig,16,6)+" "+substr(cLinhaDig,22,5)+"."+substr(cLinhaDig,27,6)+;
	" "+substr(cLinhaDig,33,1)+" "+substr(cLinhaDig,34,14)

	//----> MONTAGEM CODIGO DE BARRAS PARA SER IMPRESSO
	cCodBarAPT 	:= cBancoM + "9" +cQuaGrupo + cFatorVen + cValor + nCpoLivre

	DbSelectArea("TbBol")
	IMPRIMEBOL(@oPrn)

	TbBol->(dbSkip())
	Loop
End

DbSelectArea("TbBol")
TbBol->(dbgotop())

IF !Eof()
	IF Empty(nString)
		oPrn:Preview()
	EndIF
EndIF

TbBol->(DBcloseArea())
RETURN()


/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³          ³ Autor ³ PETERSON              ³ Data ³ 27.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula o Digito Verificador MOD10                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ DIGITO da linha digitavel alterado por Silvio 04/01/05     ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CalcDigMOD10(_cNumDig10_)
Local i         := 0
local nCont  	:= 2
local cDigito   := "0"
local nSoma  	:= 0
local nAux 	    := 0

For i:=Len(_cNumDig10_) to 1 step -1

	nAux := Val(Substr(_cNumDig10_,i,1)) * nCont
	if  nAux > 9
		nSoma += Val(Substr(Strzero(nAux,2),1,1)) + Val(Substr(Strzero(nAux,2),2,1))
	else
		nSoma += nAux
	endif

	if nCont == 2
		nCont := 1
	else
		nCont := 2
	endif

Next i

if 10-mod(nSoma,10) > 9
	cDigito := "0"
else
	nDigito := 10-mod(nSoma,10)
	cDigito := Strzero(nDigito,1)
endif
return(cDigito)

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³          ³ Autor ³ PETERSON              ³ Data ³ 27.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula o Digito Verificador MOD10                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ DIGITO DO CODIGO DE BARRAS   alterado por Silvio 04/01/05  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION CalcDigM11() //Mod11_237( cNumero ) //-> Modulo 11 especifico p/ Banco Brandesco´para digito do codigo de barras
LOCAL nCnt   := 0,;
cDigito      := 0,;
nSoma        := 0,;
nBase        := 0,;
aPeso        := {9,8,7,6,5,4,3,2};

nBase := Len(aPeso)+1

FOR nCnt  := Len(cNumDig10) TO 1 STEP -1
	nBase := IF(--nBase = 0,Len(aPeso),nBase)
	nSoma += Val(SUBS(cNumDig10,nCnt,01)) * aPeso[ nBase ]
NEXT

cDigito := 11 - (nSoma % 11)

DO CASE
	CASE cDigito = 0
		cDigito := "1"
	CASE cDigito > 9
		cDigito := "1"
	OTHERWISE
		cDigito := STR( cDigito, 1, 0 )
ENDCASE
RETURN(cDigito)


/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³          ³ Autor ³ PETERSON              ³ Data ³ 27.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressão do Boleto Bradesco                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ alterado por Silvio 04/01/05                               ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//-----------------------------> IMPRESSAO DO LAYOUT
static Function ImprimeBol(oPrn)
Local nI
oPrn:StartPage() // Começa uma nova pagina

//PRIMEIRA PARTE  - COMPROVANTE DE ENTREGA = BB
nRow1 := 0

oPrn:Line (0150,500,0070, 500)
oPrn:Line (0150,710,0070, 710)

oPrn:Say  (0084,080,"Bradesco",oFont15,100 )	    // [2]Nome do Banco
oPrn:Say  (0075,513,"237-2",oFont21,100 )	// [1]Numero do Banco

oPrn:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont15,100)
oPrn:Line (nRow1+0150,080,nRow1+0150,2300)

oPrn:Say  (nRow1+0150,080 ,"Cedente",oFont15,100)
oPrn:Say  (nRow1+0200,080 ,SM0->M0_NOMECOM,oFont15,100)				//Nome + CNPJ

oPrn:Say  (nRow1+0150,1060,"Ag/Cod Cedente",oFont15,100)
oPrn:Say  (nRow1+0200,1060,cAgenciaCedente,oFont15,100)

oPrn:Say  (nRow1+0150,1340,"Nro.Documento",oFont15,100)
oPrn:Say  (nRow1+0200,1340,TbBol->E1_NUM+ IF (!EMPTY(TbBol->E1_PARCELA),'/'+TbBol->E1_PARCELA,' '),oFont15,100) //Prefixo +Numero+Parcela

oPrn:Say  (nRow1+0150,1600,"Nosso Número",oFont15,100)
oPrn:Say  (nRow1+0200,1600, cNossoNum,oFont15,100) //Prefixo +Numero+Parcela

oPrn:Say  (nRow1+0250,080 ,"Sacado",oFont15,100)
oPrn:Say  (nRow1+0300,080 ,TbBol->A1_NOME,oFont15,100)				//Nome

oPrn:Say  (nRow1+0250,1060,"Vencimento",oFont15,100)
oPrn:Say  (nRow1+0300,1060,SUBSTR(DTOS(TbBol->E1_VENCTO),7,2)+"/"+SUBSTR(DTOS(TbBol->E1_VENCTO),5,2)+"/"+SUBSTR(DTOS(TbBol->E1_VENCTO),1,4),oFont15,100)

oPrn:Say  (nRow1+0250,1600,"Valor do Documento",oFont15,100)
oPrn:Say  (nRow1+0300,1650,Transform(TbBol->E1_SALDO,"@E 9,999,999.99"),oFont15,100)

oPrn:Say  (nRow1+0400,0080,"Recebi(emos) o bloqueto/título",oFont15,100)
oPrn:Say  (nRow1+0450,0080,"com as características acima.",oFont15,100)
oPrn:Say  (nRow1+0350,1060,"Data",oFont15,100)
oPrn:Say  (nRow1+0350,1410,"Assinatura",oFont15,100)
oPrn:Say  (nRow1+0450,1060,"Data",oFont15,100)
oPrn:Say  (nRow1+0450,1410,"Entregador",oFont15,100)

oPrn:Line (nRow1+0250, 080,nRow1+0250,1900 )
oPrn:Line (nRow1+0350, 080,nRow1+0350,1900 )
oPrn:Line (nRow1+0450,1050,nRow1+0450,1900 )
oPrn:Line (nRow1+0550, 080,nRow1+0550,2300 )

oPrn:Line (nRow1+0250,1330,nRow1+0150,1330 )
oPrn:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrn:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrn:Line (nRow1+0350,1590,nRow1+0150,1590 )
oPrn:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrn:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont15,100)
oPrn:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont15,100)
oPrn:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont15,100)
oPrn:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont15,100)
oPrn:Say  (nRow1+0325,1910,"(  )Não procurado"                            ,oFont15,100)
oPrn:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont15,100)
oPrn:Say  (nRow1+0405,1910,"(  )Desconhecido"                             ,oFont15,100)
oPrn:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont15,100)
oPrn:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  ,oFont15,100)

//Pontilhado separador
For nI := 080 to 2300 step 50
	oPrn:Line(0580, nI,0580, nI+30)
Next nI

nRow1:=450// aonde terminou a primeira parte
//ESTA PASSARA A SER A SEGUNDA PARTE
oPrn:Say ( nRow1+0265, 1800, "RECIBO DO SACADO",oFont15,100)

oPrn:SayBitmap( nRow1+0200, 0068,cUBANBitMap,250,90)
oPrn:Say( nRow1+0235, 0575, cPrintBanc,oFont21,100)

oPrn:Box (nRow1+0300, 0056, nRow1+1390, 2300)  //ju - ok   - Box geral da segunda parte

// Monta linhas horizontais
//        lin         col   lin         col
oPrn:line(nRow1+0380, 0056, nRow1+0380, 2300)
oPrn:Line(nRow1+0465, 0056, nRow1+0465, 2300)
oPrn:Line(nRow1+0550, 0056, nRow1+0550, 2300)
oPrn:Line(nRow1+0635, 0056, nRow1+0635, 2300)
oPrn:Line(nRow1+0720, 0056, nRow1+0720, 2300)

oPrn:Line(nRow1+0805, 1620, nRow1+0805, 2300)
oPrn:Line(nRow1+0890, 1620, nRow1+0890, 2300)
oPrn:Line(nRow1+0975, 1620, nRow1+0975, 2300)
oPrn:Line(nRow1+1060, 1620, nRow1+1060, 2300)


oPrn:Line(nRow1+1145, 0056, nRow1+1145, 2300)

// Monta linha verticais
//        lin         col   lin         col
oPrn:Line(nRow1+0220, 0560, nRow1+0300, 0560)
oPrn:Line(nRow1+0220, 0561, nRow1+0300, 0561)
oPrn:Line(nRow1+0220, 0562, nRow1+0300, 0562)
oPrn:Line(nRow1+0220, 0740, nRow1+0300, 0740)
oPrn:Line(nRow1+0220, 0741, nRow1+0300, 0741)
oPrn:Line(nRow1+0220, 0742, nRow1+0300, 0742)

oPrn:Line(nRow1+0300, 1620, nRow1+1390, 1620) //ju -linha vertical - parte 2

oPrn:Line(nRow1+0550, 0450, nRow1+0720, 0450)
oPrn:Line(nRow1+0550, 0850, nRow1+0720, 0850)
oPrn:Line(nRow1+0550, 1140, nRow1+0635, 1140)
oPrn:Line(nRow1+0550, 1320, nRow1+0720, 1320)
IF !Empty(cPrUsoBc)
	oPrn:Line(nRow1+0635, 0300, nRow1+0720, 0300)
EndIF
oPrn:Line(nRow1+0635, 0600, nRow1+0720, 0600)

oPrn:Say( nRow1+0310, 0080, "Local de Pagamento "     			,oFont15,100 )
oPrn:Say( nRow1+0310, 0364, MsnLocPg 				   	 		,oFont15,100 )
oPrn:Say( nRow1+0340, 0364, MsnLocPg2 					 		,oFont15,100 )
oPrn:Say( nRow1+0390, 0080, "BENEFICIÁRIO"                	    ,oFont15,100 )
oPrn:Say( nRow1+0420, 0080, SUBSTR(SM0->M0_NOMECOM,1,150)		,oFont12,100 )
oPrn:Say( nRow1+0420, 1100, "CNPJ: "+SUBS(SM0->M0_CGC,1,2)+"."+SUBS(SM0->M0_CGC,3,3)+"."+SUBS(SM0->M0_CGC,6,3)+"/"+SUBS(SM0->M0_CGC,9,4)+"-"+SUBS(SM0->M0_CGC,13,2),oFont12,100)
oPrn:Say( nRow1+0475, 0080, "Endereço do Beneficiário "         ,oFont15,100  )
oPrn:Say( nRow1+0515, 0080, AllTrim(SM0->M0_ENDENT)+" - "+AllTrim(SM0->M0_COMPENT)+" - "+ AllTrim(SM0->M0_BAIRENT) +" - " +AllTrim(SM0->M0_CIDENT)+"/"+ AllTrim(SM0->M0_ESTENT) +" - "+ AllTrim(Transform(SM0->M0_CEPENT, "@R 99.999-999"))   ,oFont24,100)   //+"   Tel: "+ AllTrim(Transform(SM0->M0_TEL, "@R 99999999999999"))

oPrn:Say( nRow1+0560, 0080, "Data Documento "            	,oFont15,100  )
oPrn:Say( nRow1+0560, 0470, "Número do Documento "       	,oFont15,100  )
oPrn:Say( nRow1+0560, 0860, "Especie do Doc "      			,oFont15,100  )
oPrn:Say( nRow1+0560, 1150, "Aceite "                    	,oFont15,100  )
oPrn:Say( nRow1+0560, 1330, "Processamento "     			,oFont15,100  )

oPrn:Say( nRow1+0590, 0124, SUBSTR(DTOS(TbBol->E1_EMISSAO),7,2)+"/"+SUBSTR(DTOS(TbBol->E1_EMISSAO),5,2)+"/"+SUBSTR(DTOS(TbBol->E1_EMISSAO),1,4) , oFont12,100 )
oPrn:Say( nRow1+0590, 0530, TbBol->E1_PREFIXO+" "+TbBol->E1_NUM+ IF (!EMPTY(TbBol->E1_PARCELA),'/'+TbBol->E1_PARCELA,' '), oFont12,100  )
oPrn:Say( nRow1+0590, 0950, "DM"                         	, oFont12,100 )
oPrn:Say( nRow1+0590, 1200, "N"                          	, oFont12,100 )
oPrn:Say( nRow1+0590, 1370, SUBSTR(DTOS(DDATABASE),7,2)+"/"+SUBSTR(DTOS(DDATABASE),5,2)+"/"+SUBSTR(DTOS(DDATABASE),1,4)  , oFont12,100 )
IF !empty(cPrUsoBc)
	oPrn:Say( nRow1+0645, 0080, "Uso do Banco "             ,oFont15,100  )
	oPrn:Say( nRow1+0645, 0310, "Cip "			            ,oFont15,100  )
Else
	oPrn:Say( nRow1+0645, 0080, "Nº da Conta / Respons "    ,oFont15,100  )
EndIF
oPrn:Say( nRow1+0645, 0470, "Carteira "			       		,oFont15,100  )
oPrn:Say( nRow1+0645, 0620, "Especie Moeda "             	,oFont15,100  )
oPrn:Say( nRow1+0645, 0860, "Quantidade "                	,oFont15,100  )
oPrn:Say( nRow1+0645, 1330, "Valor "                     	,oFont15,100  )
oPrn:Say( nRow1+0675, 0124, cPrUsoBc                      	,oFont12,100  )
oPrn:Say( nRow1+0675, 0530, cCartei                      	,oFont12,100  )
oPrn:Say( nRow1+0675, 0700, "R$"                         	,oFont12,100  )

oPrn:Say( nRow1+0730, 0080, "Instruções (Todas informações deste BOLETO são de exclusiva responsabilidade do cedente)"  ,oFont13,100  )
oPrn:Say( nRow1+0730, 0910, "*** Valores expressos em R$ *** "    ,oFont13,100  )
oPrn:Say( nRow1+0770, 0124, "Após o vencimento, cobrar R$ "+alltrim(str(njuros,10,2))+" por dia de atraso."  ,oFont18,100  )
//oPrn:Say( nRow1+0810, 0124, "Após o vencimento, cobrar multa de 2% " ,oFont18,100  )
oPrn:Say( nRow1+0850, 0124, MsgInstr02 ,oFont18,100  )
oPrn:Say( nRow1+0930, 0124, MsgInstr03 ,oFont18,100  )

oPrn:Say( nRow1+0310, 1633, "Vencimento "            			,oFont15,100  )
oPrn:Say( nRow1+0340, 1900, SUBSTR(DTOS(TbBol->E1_VENCTO),7,2)+"/"+SUBSTR(DTOS(TbBol->E1_VENCTO),5,2)+"/"+SUBSTR(DTOS(TbBol->E1_VENCTO),1,4)    ,oFont15,100  )
oPrn:Say( nRow1+0395, 1633, "Agência/Código Beneficiário"		,oFont15,100  )
oPrn:Say( nRow1+0425, 1848, cAgenciaCedente 		       		,oFont12,100  )
oPrn:Say( nRow1+0480, 1633, "Cart/Nosso Numero "         		,oFont15,100  )
oPrn:Say( nRow1+0510, 1850, cNossoNum                    		,oFont12,100  )
oPrn:Say( nRow1+0565, 1633, "1(=)Valor do Documento "           ,oFont15,100  )
oPrn:Say( nRow1+0595, 1875, TRANSF(nvalliq,"@E 999,999.99") 	,oFont12,100  )
oPrn:Say( nRow1+0650, 1633, "2(-) Desconto/abatimento "         ,oFont15,100  )
oPrn:Say( nRow1+0735, 1633, "3(-) Outras deduções "             ,oFont15,100  )
oPrn:Say( nRow1+0820, 1633, "4(+) Mora/Multa/Juros "  			,oFont15,100  )
oPrn:Say( nRow1+0905, 1633, "5(+) Outros Acréscimos "  			,oFont15,100  )
oPrn:Say( nRow1+0990, 1633, "6(=) Valor Cobrado "     			,oFont15,100  )

//oPrn:Say( nRow1+1645, 0080, n_vias ,oFont13,100  )
oPrn:Say( nRow1+1125, 0080, "PAGADOR"                 			,oFont13,100  )

oPrn:Say( nRow1+1155, 0200, TbBol->E1_CLIENTE + " - " + ALLTRIM(cNome), oFont12,100  )
if len(Alltrim(TbBol->A1_CGC)) > 11
	oPrn:Say( nRow1+1155, 1200,"CNPJ: " + SUBS(TbBol->A1_CGC,1,2)+"."+SUBS(TbBol->A1_CGC,3,3)+"."+SUBS(TbBol->A1_CGC,6,3)+"/"+SUBS(TbBol->A1_CGC,9,4)+"-"+SUBS(TbBol->A1_CGC,13,2), oFont12,100  )
else
	oPrn:Say( nRow1+1155, 1200,"CPF: " + SUBS(TbBol->A1_CGC,1,3)+"."+SUBS(TbBol->A1_CGC,4,3)+"."+SUBS(TbBol->A1_CGC,6,3)+"-"+SUBS(TbBol->A1_CGC,10,2), oFont12,100  )
endif

oPrn:Say( nRow1+1205, 0200, ALLTRIM(TbBol->A1_END)+"-"+ALLTRIM(TbBol->A1_COMPLEM), oFont12,100)
oPrn:Say( nRow1+1255, 0200, Substr(TbBol->A1_CEP,1,5)+"-"+Substr(TbBol->A1_CEP,6,3)+"  "+ALLTRIM(TbBol->A1_BAIRRO)+" - "+ALLTRIM(TbBol->A1_MUN)+" - "+TbBol->A1_EST, oFont12,100  )

oPrn:Say( nRow1+1400, 0080, "Sacado / Avalista: "            ,oFont15,100  )
oPrn:Say( nRow1+1400, 1850, "Autenticação Mecânica  "        ,oFont15,100  )



oPrn:Say( nRow1+1485, 0080, " ------------------------------------------------------------------------------------------------------------------------------------",oFont12,100)

nRow1:=nRow1-500
//******************************************
//----------------------------------------->  MONTA FICHA COMPENSAÇÃO
//******************************************
oPrn:SayBitmap( nRow1+2190, 0068,cUBANBitMap,250,90)
oPrn:Say( nRow1+2225, 0575, cPrintBanc ,oFont21,100)
oPrn:Say( nRow1+2230, 0900, cLinhaDigImp             ,oFont4,100)

// Monta box do boleto
oPrn:Box (nRow1+2290, 0056, nRow1+3170, 2300)

// Monta linhas horizontais
oPrn:Line(nRow1+2370, 0056, nRow1+2370, 2300)
oPrn:Line(nRow1+2450, 0056, nRow1+2450, 2300)
oPrn:Line(nRow1+2530, 0056, nRow1+2530, 2300)
oPrn:Line(nRow1+2610, 0056, nRow1+2610, 2300)
oPrn:Line(nRow1+2690, 1620, nRow1+2690, 2300)
oPrn:Line(nRow1+2770, 1620, nRow1+2770, 2300)
oPrn:Line(nRow1+2850, 1620, nRow1+2850, 2300)
oPrn:Line(nRow1+2930, 1620, nRow1+2930, 2300)
oPrn:Line(nRow1+3010, 0056, nRow1+3010, 2300)

// Monta linha verticais
oPrn:Line(nRow1+2210, 0560, nRow1+2290, 0560)
oPrn:Line(nRow1+2210, 0561, nRow1+2290, 0561)
oPrn:Line(nRow1+2210, 0562, nRow1+2290, 0562)
oPrn:Line(nRow1+2210, 0740, nRow1+2290, 0740)
oPrn:Line(nRow1+2210, 0741, nRow1+2290, 0741)
oPrn:Line(nRow1+2210, 0742, nRow1+2290, 0742)

oPrn:Line(nRow1+2290, 1620, nRow1+3011, 1620)
oPrn:Line(nRow1+2451, 0450, nRow1+2610, 0450)
oPrn:Line(nRow1+2451, 0850, nRow1+2610, 0850)
oPrn:Line(nRow1+2451, 1140, nRow1+2530, 1140)
oPrn:Line(nRow1+2451, 1320, nRow1+2610, 1320)
oPrn:Line(nRow1+2530, 0300, nRow1+2610, 0300)
oPrn:Line(nRow1+2530, 0600, nRow1+2610, 0600)


oPrn:Say( nRow1+2300, 0080, "Local de Pagamento "    			,oFont15,100  )
oPrn:Say( nRow1+2300, 1633, "Vencimento "            			,oFont15,100  )
oPrn:Say( nRow1+2300, 0364, MsnLocPg,oFont15,100  )
oPrn:Say( nRow1+2330, 0364, MsnLocPg2,oFont15,100  )
oPrn:Say( nRow1+2330, 1904,  SUBSTR(DTOS(TbBol->E1_VENCTO),7,2)+"/"+SUBSTR(DTOS(TbBol->E1_VENCTO),5,2)+"/"+SUBSTR(DTOS(TbBol->E1_VENCTO),1,4) ,oFont15,100  )
oPrn:Say( nRow1+2380, 0080, "BENEFICIÁRIO "                   	,oFont15,100 )
oPrn:Say( nRow1+2380, 1633, "Agência/Código Beneficiário"       ,oFont15,100 )
oPrn:Say( nRow1+2410, 0124, SUBSTR(SM0->M0_NOMECOM,1,150)		,oFont12,100 )
oPrn:Say( nRow1+2410, 1100, "CNPJ: "+SUBS(SM0->M0_CGC,1,2)+"."+SUBS(SM0->M0_CGC,3,3)+"."+SUBS(SM0->M0_CGC,6,3)+"/"+SUBS(SM0->M0_CGC,9,4)+"-"+SUBS(SM0->M0_CGC,13,2),oFont12,100)
oPrn:Say( nRow1+2410, 1848, cAgenciaCedente 		       		,oFont12,100 )
oPrn:Say( nRow1+2460, 0080, "Data Documento "  		          	,oFont15,100  )
oPrn:Say( nRow1+2460, 0470, "Numero do Documento "             	,oFont15,100  )
oPrn:Say( nRow1+2460, 0860, "Espécie Doc. " 	             	,oFont15,100  )
oPrn:Say( nRow1+2460, 1150, "Aceite "                    		,oFont15,100  )
oPrn:Say( nRow1+2460, 1330, "Processamento "     				,oFont15,100  )
oPrn:Say( nRow1+2460, 1633, "Cart/Nosso Numero "         		,oFont15,100  )
oPrn:Say( nRow1+2490, 0124,  SUBSTR(DTOS(TbBol->E1_EMISSAO),7,2)+"/"+SUBSTR(DTOS(TbBol->E1_EMISSAO),5,2)+"/"+SUBSTR(DTOS(TbBol->E1_EMISSAO),1,4)  , oFont12,100 )
oPrn:Say( nRow1+2490, 0530,  TbBol->E1_PREFIXO+" "+TbBol->E1_NUM+ IF (!EMPTY(TbBol->E1_PARCELA),'/'+TbBol->E1_PARCELA,' '), oFont12,100  )
oPrn:Say( nRow1+2490, 0950, "DM"                         		, oFont12,100 )
oPrn:Say( nRow1+2490, 1200, "N"                          		, oFont12,100 )
//IF EMPTY(TbBol->E1_UDTPROC)
oPrn:Say( nRow1+2490, 1370, SUBSTR(DTOS(DDATABASE),7,2)+"/"+SUBSTR(DTOS(DDATABASE),5,2)+"/"+SUBSTR(DTOS(DDATABASE),1,4)  , oFont12,100 )
//Else
//	oPrn:Say( 2490, 1370, SUBSTR(DTOS(TbBol->E1_UDTPROC),7,2)+"/"+SUBSTR(DTOS(TbBol->E1_UDTPROC),5,2)+"/"+SUBSTR(DTOS(TbBol->E1_UDTPROC),1,4) , oFont12,100 )
//Endif
oPrn:Say( nRow1+2490, 1850, cNossoNum                    		,oFont12,100 )
IF !empty(cPrUsoBc)
	oPrn:Say( nRow1+2540, 0080, "Uso do Banco "              	,oFont15,100 )
	oPrn:Say( nRow1+2540, 0310, "Cip "			           		,oFont15,100 )
Else
	oPrn:Say( nRow1+2540, 0080, "Nº da Conta / Respons "     	,oFont15,100 )
EndIF
oPrn:Say( nRow1+2540, 0470, "Carteira "			       	 		,oFont15,100 )
oPrn:Say( nRow1+2540, 0620, "Espécie Moeda "             		,oFont15,100 )
oPrn:Say( nRow1+2540, 0860, "Quantidade "                		,oFont15,100 )
oPrn:Say( nRow1+2540, 1330, "Valor "                     		,oFont15,100 )
oPrn:Say( nRow1+2540, 1633, "1(=)Valor do Documento "    		,oFont15,100 )
oPrn:Say( nRow1+2570, 0124, cPrUsoBc                     		,oFont12,100 )
oPrn:Say( nRow1+2570, 0530, cCartei                         	,oFont12,100 )
oPrn:Say( nRow1+2570, 0700, "R$"                         		,oFont12,100 )
oPrn:Say( nRow1+2570, 1875, TRANSF(nvalliq,"@E 999,999.99") 	,oFont12,100 )
oPrn:Say( nRow1+2620, 0080, "Instruções (Todas informações deste BOLETO são de exclusiva responsabilidade do cedente)"            ,oFont13,100  )
oPrn:Say( nRow1+2620, 0910, "*** Valores expressos em R$ *** "   ,oFont13,100 )
oPrn:Say( nRow1+2620, 1633, "2(-) Desconto/abatimento "          ,oFont15,100 )

oPrn:Say( nRow1+2700, 1633, "3(-) Outras deduções "         ,oFont15,100  )
oPrn:Say( nRow1+2780, 1633, "(+) Mora/Multa/Juros "  		,oFont15,100  )
oPrn:Say( nRow1+2860, 1633, "(+) Outros Acrescimos "  		,oFont15,100  )
oPrn:Say( nRow1+2940, 1633, "(=) Valor Cobrado "     		,oFont15,100  )
oPrn:Say( nRow1+2660, 0124, "Após o vencimento, cobrar R$ "+alltrim(str(njuros,10,2))+" por dia de atraso." ,oFont18,100  )
oPrn:Say( nRow1+2740, 0124, MsgInstr02 						,oFont18,100  )
oPrn:Say( nRow1+2820, 0124, MsgInstr03 						,oFont18,100  )
oPrn:Say( nRow1+3020, 0080, "PAGADOR"                 		,oFont13,100  )

oPrn:Say( nRow1+3025, 0200, TbBol->E1_CLIENTE + " - " + ALLTRIM(cNome), oFont12,100  )
If len(Alltrim(TbBol->A1_CGC)) > 11
	oPrn:Say( nRow1+3025, 1200,"CNPJ: " + SUBS(TbBol->A1_CGC,1,2)+"."+SUBS(TbBol->A1_CGC,3,3)+"."+SUBS(TbBol->A1_CGC,6,3)+"/"+SUBS(TbBol->A1_CGC,9,4)+"-"+SUBS(TbBol->A1_CGC,13,2), oFont12,100  )
else
	oPrn:Say( nRow1+3025, 1200,"CPF: " + SUBS(TbBol->A1_CGC,1,3)+"."+SUBS(TbBol->A1_CGC,4,3)+"."+SUBS(TbBol->A1_CGC,6,3)+"-"+SUBS(TbBol->A1_CGC,10,2), oFont12,100  )
endif
oPrn:Say( nRow1+3065, 0200, ALLTRIM(TbBol->A1_END)+"-"+Alltrim(TbBol->A1_COMPLEM), oFont12,100)
oPrn:Say( nRow1+3105, 0200, Substr(TbBol->A1_CEP,1,5)+"-"+Substr(TbBol->A1_CEP,6,3)+"  "+ALLTRIM(TbBol->A1_BAIRRO)+" - "+ALLTRIM(TbBol->A1_MUN)+" - "+TbBol->A1_EST, oFont12,100  )

oPrn:Say( nRow1+3148, 0080, "Pagador / Avalista: "                                   ,oFont13,100  )
oPrn:Say( nRow1+3185, 1650, "Autenticação Mecânica  /  Ficha de Compensação"         ,oFont13,100  )
/*Ajuste os parâmetros no msbar(.....)


±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras      		   		  ³±±
±±³          ³                      "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"  	  ³±±
±±³          ³                      "INT25","MAT25,"IND25","CODABAR","CODE3_9"  	  ³±±
±±³          ³ 02 nRow              Numero da Linha em centimentros            		  ³±±
±±³          ³ 03 nCol              Numero da coluna em centimentros           	      ³±±
±±³          ³ 04 cCode             String com o conteudo do codigo  			      ³±±
±±³          ³ 05 oPr               Obejcto Printer                            		  ³±±
±±³          ³ 06 					lcheck Se calcula o digito de controle            ³±±
±±³          ³ 07 Cor               Numero  da Cor, utilize a "common.ch"             ³±±
±±³          ³ 08 lHort             Se imprime na Horizontal                          ³±±
±±³          ³ 09 nWidth            Numero do Tamanho da barra em centimetros         ³±±
±±³          ³ 10 nHeigth          	Numero da Altura da barra em milimetros           ³±±
±±³          ³ 11 lBanner          	Se imprime o linha em baixo do codigo             ³±±
±±³          ³ 12 cFont             String com o tipo de fonte                        ³±±
±±³          ³ 13 cMode             String com o modo do codigo de barras CODE128     ³±±
*/

MSBAR("INT25", 27.6 ,1.6,cCodBarAPT,oPrn,.f.,NIL,.T.,0.0250,1.3,NIL,NIL,NIL,LPRINT)
//MSBAR("INT25", 27.6 ,1.0,"0005966",oPrn,.T.,NIL,.T.,0.03,1.3,NIL,NIL,NIL,LPRINT)

oPrn:EndPage()

return()



//=================================================================================//
Static Function DigVerfNSNum(cBanco, cAgencia, cConta, cCarteira, cNosNum)
Local _Ret:=""
Do Case
	Case cBanco == "237" // Bradesco
		_Ret := cNosNum + CalcDigNNum(11,cCarteira+cNosNum,{2,7,6,5,4,3},"P",.T.,.F.)    // controle do digito verificador do nosso numero ( Bradesco gerencia como controle "X"
	Case cBanco == "001" //Banco Brasil
		_Ret := cNosNum + CalcDigNNum(11,cNosNum,{2,3,4,5,6,7,8,9},"X",.F.,.F.)
	Case cBanco == "341"// Banco Itaú
		_Ret := cNosNum + CalcDigNNum(10,cAgencia+substr(cConta,1,5)+cNosNum,{1,2},"0",.T.,.T.)
EndCase

_Ret := Alltrim(_Ret)
Return(_Ret)


//=================================================================================//
Static Function CalcDigNNum(nDiv,nNumero,aPeso,cLetra,lSubr,lSomaDec)
LOCAL nCnt     := 0
Local cDigito  := 0
Local nSoma    := 0
Local nBase    := 1
Local nVlrSoma := 0

For nCnt:= 1 to Len(nNumero)
	nVlrSoma += Val(SUBS(nNumero,nCnt,01)) * aPeso[ nBase ]
	nBase++
	If nBase > 6
		nBase := 1
	EndIf
NEXT nCnt

cDigito := nVlrSoma % 11//IIF(lSubr, nDiv - (nSoma % nDiv), (nSoma % nDiv))

DO CASE
	CASE cDigito = 0 // Somente entrará nessa condição se lSubr for igual a .t. e a variavel nDiv =11
		cDigito := "0"
	CASE cDigito = 1 .AND. !Empty(cLetra)
		cDigito := cLetra
	OTHERWISE
		cDigito := STR( 11 - cDigito, 1 )
ENDCASE

RETURN(cDigito)

User Function VrLiQSE1()
Local nValLiq
nValLiq:= SE1->E1_SALDO - SOMAABAT(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
Return nValLiq
