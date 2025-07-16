#Include "protheus.ch"
#Include "rwmake.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BLTITAU  ºAutor  ³Microsiga           º Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de boleto Itau                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function BLTITAU(__cNotFis)

oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )

#define DS_MODALFRAME   128
DEFINE MsDialog oDlg1 From 0,0 To 350,300 Title "EMISSÃO DE BOLETOS" Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.
//oDlg1:lTEscClose := .F.

oSay1      := TSay():New( 05,25,{||"EMISSÃO DE BOLETOS"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oSay1      := TSay():New( 20,45,{||"      BANCO       "},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oTBitmap1  := TBitmap():New(35,35,150,150,,"LOGO_ITAU.PNG",.T.,oDlg1,,,.F.,.F.,,,.F.,,.T.,,.F.)

oBtn1      := TButton():New( 150,025,"OK",oDlg1,{|| OK()},035,015,,oFont2,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 150,100,"Cancelar",oDlg1,{|| oDlg1:End()},035,015,,oFont2,,.T.,,"",,,,.F. )

ACTIVATE DIALOG oDlg1 CENTERED
Return(.T.)

Static Function OK(__cNotFis)

//declaracao de variaveis
Local	__aPrgSX1 := {}
Private __lExeFnc := .t.
Private __cIdxNam := ''
Private __cIdxKey := ''
Private __cFilter := ''
Private __cCartei	:= "109"
Private __cMoedas := "9"


Default __cNotFis := Space(09)

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .f.
cPerg    := Padr("BLTITAU",10)
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
__cNumNot	:= __cNotFis

Close(oDlg1)

//If SM0->M0_CODIGO <> "31"
//MSGALERT("EMPRESA NAO AUTORIZADA A EMITIR BOLETO ITAU")
//Return Nil
//ENDIF

dbSelectArea("SE1")

PutSx1(cPerg,"01","De Prefixo"	 ,"","","mv_ch1","C", 3,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"02","Ate Prefixo"	 ,"","","mv_ch2","C", 3,0,0,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"03","De Numero"		 ,"","","mv_ch3","C", 9,0,0,"G","","SE1","","","mv_par03","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"04","Ate Numero"	 ,"","","mv_ch4","C", 9,0,0,"G","","SE1","","","mv_par04","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"05","De Parcela"	 ,"","","mv_ch5","C", 1,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"06","Ate Parcela"	 ,"","","mv_ch6","C", 1,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"07","De Portador"	 ,"","","mv_ch7","C", 3,0,0,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"08","Ate Portador"  ,"","","mv_ch8","C", 3,0,0,"G","",""   ,"","","mv_par08","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"09","De Cliente"	 ,"","","mv_ch9","C", 6,0,0,"G","","SA1","","","mv_par09","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"10","Ate Cliente"	 ,"","","mv_cha","C", 6,0,0,"G","","SA1","","","mv_par10","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"11","De Loja"		 ,"","","mv_chb","C", 2,0,0,"G","",""   ,"","","mv_par11","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"12","Ate Loja"		 ,"","","mv_chc","C", 2,0,0,"G","",""   ,"","","mv_par12","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"13","De Emissao"	 ,"","","mv_chd","D", 8,0,0,"G","",""   ,"","","mv_par13","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"14","Ate Emissao"	 ,"","","mv_che","D", 8,0,0,"G","",""   ,"","","mv_par14","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"15","De Vencimento" ,"","","mv_chf","D", 8,0,0,"G","",""   ,"","","mv_par15","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"16","Ate Vencimento","","","mv_chg","D", 8,0,0,"G","",""   ,"","","mv_par16","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"17","Do Bordero"	 ,"","","mv_chh","C", 6,0,0,"G","",""   ,"","","mv_par17","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"18","Ate Bordero"   ,"","","mv_chi","C", 6,0,0,"G","",""   ,"","","mv_par18","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"19","Banco"    		 ,"","","mv_chj","C", 3,0,0,"G","","SA6","","","mv_par19","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"20","Agencia"   	 ,"","","mv_chl","C", 5,0,0,"G","",""   ,"","","mv_par20","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"21","Conta"   		 ,"","","mv_chm","C",10,0,0,"G","",""   ,"","","mv_par21","","","","","","","","","","","","","","","","",{},{},{})
PutSx1(cPerg,"22","Origem"   		 ,"","","mv_chn","C", 1,0,0,"G","",""   ,"","","mv_par22","","","","","","","","","","","","","","","","",{},{},{})
If !Pergunte (cPerg,.t.)
	Return
Endif

If Empty(__cNumNot)
	__cIdxNam := Criatrab(Nil,.f.)
	__cidxkey := "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"
	__cFilter += "E1_FILIAL == '"+xFilial("SE1")+"' .and. E1_SALDO > 0 .and. "
	__cFilter += "E1_PREFIXO >= '" + mv_par01 + "' .and. E1_PREFIXO<='" + mv_par02 + "' .and. "
	__cFilter += "E1_NUM >= '" + mv_par03 + "' .and. E1_NUM <= '" + mv_par04 + "' .and. "
	__cFilter += "E1_PARCELA >= '" + mv_par05 + "' .and. E1_PARCELA <= '" + mv_par06 + "' .and. "
	__cFilter += "E1_CLIENTE >= '" + mv_par09 + "' .and. E1_CLIENTE <= '" + mv_par10 + "' .and. "
	__cFilter += "E1_LOJA >= '" + mv_par11 + "' .and. E1_LOJA <= '"+mv_par12+"' .and. "
	__cFilter += "DtoS(E1_EMISSAO) >= '"+DtoS(mv_par13)+"' .and. DtoS(E1_EMISSAO) <= '"+DtoS(mv_par14)+"' .and. "
	__cFilter += "DtoS(E1_VENCREA) >= '"+DtoS(mv_par15)+"' .and. DtoS(E1_VENCREA) <= '"+DtoS(mv_par16)+"' .and. "
	__cFilter += "E1_NUMBOR >= '" + mv_par17 + "' .and. E1_NUMBOR <= '" + mv_par18 + "' .and. "
	__cFilter += "!(E1_TIPO$MVABATIM).And. "
	__cFilter += "E1_PAGTO='BO'.And."
	__cFilter += "E1_EMISNF = '" + mv_par22+ "' " //"E1_EMISNF = '1'" //E1_EMISNF = '" + mv_par22+ "' "
//	__cFilter += "E1_EMISNF='2'"
	If Empty(mv_par19)
		__cFilter += ".and. E1_PORTADO >= '" + mv_par07 + "' .and. E1_PORTADO <= '" + mv_par08 + "' "
		__cFilter += ".and. E1_PORTADO <> '   '"
	Endif
Else
	__cFilter		+= "E1_NUM = '" + __cNumNot + "' "
Endif

//aviso("Confirmacao","Deseja Gerar Boleto do banco ITAU",{"SIM","NAO",(__lExeFnc)})
//__cidxkey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"

// original 	__cIdxKey := "ÁE1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DtoS(E1_EMISSAO)"
IndRegua("SE1", __cIdxNam, __cIdxKey,, __cFilter, "Aguarde selecionando registros....")
dbSelectArea("SE1")

#IFNDEF TOP
	dbSetIndex(__cIdxNam + OrdBagExt())
#ENDIF

dbGoTop()

If Empty(__cNumNot)
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (__lExeFnc := .t.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (__lExeFnc := .f.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
	dbGoTop()
Else
	__lExeFnc := .t.
Endif

If __lExeFnc
	Processa({|lEnd| MontaRel()})
Endif
RetIndex("SE1")
Ferase(__cIdxNam+OrdBagExt())
Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MONTAREL ºAutor  ³Microsiga           º Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function MontaRel()

//declaracao de variaveis
Local __oPrnBol
Local __cNroDoc := " "
Local __aInfEmp := {	SM0->M0_NOMECOM                                    								,; //[1]Nome da Empresa
							SM0->M0_ENDCOB                                     								,; //[2]Endereço
							AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB  ,; //[3]Complemento
							"CEP: "+SubStr(SM0->M0_CEPCOB,1,5)+"-"+SubStr(SM0->M0_CEPCOB,6,3)          ,; //[4]CEP
							"PABX/FAX: "+SM0->M0_TEL                                                   ,; //[5]Telefones
							"CNPJ: "+SubStr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+           ; //[6]
							SubStr(SM0->M0_CGC,6,3)+"/"+SubStr(SM0->M0_CGC,9,4)+"-"+                    ; //[6]
							SubStr(SM0->M0_CGC,13,2)                                                   ,; //[6]CGC
							"I.E.: "+SubStr(SM0->M0_INSC,1,3)+"."+SubStr(SM0->M0_INSC,4,3)+"."+         ; //[7]
							SubStr(SM0->M0_INSC,7,3)+"."+SubStr(SM0->M0_INSC,10,3)                      } //[7]I.E

Local __aDadTit := {}
Local __aDadBco := {}
Local __aDadSac := {}
Local __aBolTxt := {"APOS O VENCIMENTO COBRAR MORA DE R$....... ","PROTESTAR NO DIA ","AO DIA","ATENCAO-->> SR. CAIXA NÃO RECEBER APOS O VENCIMENTO"}
Local __cMntBar := {}
Local __nVlrAbt := 0
Local __cNosNum := ""
Local __cDigNum := ""

Private cStartPath := GetSrvProfString("Startpath","")

__oPrnBol:= TMSPrinter():New("Boleto Laser")
__oPrnBol:SetPortrait() // ou SetLandscape()
__oPrnBol:Setup()   // Inicia uma nova página

dbGoTop()
ProcRegua(RecCount())
While !EOF()

	If Marked("E1_OK")

		If Empty(mv_par19)
			//Posiciona o SA6 (Bancos)
			dbSelectArea("SA6")
			dbSetOrder(1)
			dbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.t.)

			//Posiciona na Arq de Parametros CNAB
			dbSelectArea("SEE")
			dbSetOrder(1)
			dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.t.)
		Else
			//Posiciona o SA6 (Bancos)
			dbSelectArea("SA6")
			dbSetOrder(1)
			dbSeek(xFilial("SA6")+mv_par19+mv_par20+mv_par21,.t.)

			//Posiciona na Arq de Parametros CNAB
			dbSelectArea("SEE")
			dbSetOrder(1)
			dbSeek(xFilial("SEE")+mv_par19+mv_par20+mv_par21,.t.)
		Endif

		//posiciona no pedido
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+SE1->E1_PEDIDO,.t.)

		If !empty(SC5->C5_CLIENTC+SC5->C5_LOJACOB).and.(SC5->C5_FILIAL+SC5->C5_NUM==SE1->E1_FILIAL+SE1->E1_PEDIDO)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SC5->C5_CLIENTC+SC5->C5_LOJACOB,.t.)
		Else
			//Posiciona o SA1 (Cliente)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.t.)
		Endif

		dbSelectArea("SE1")
		If Empty(SE1->E1_NUMBCO)
			__cNosNum := Right(Alltrim(NossoNum()),8)
			__cNosNum := Left(Alltrim(SA6->A6_AGENCIA),4) + Left(Alltrim(Alltrim(SA6->A6_NUMCON)),5) + Alltrim(__cCartei) + __cNosNum
			__cNosNum += Alltrim(Str(Modulo10(__cNosNum)))
			RecLock("SE1",.f.)
			SE1->E1_NUMBCO := Right(Alltrim(__cNosNum),9)
			SE1->E1_NOMEUSE  := CUSERNAME                       // NOME DO USUARIO QUE GEROU O BOLETO
			SE1->E1_BKPNNUM  := SE1->E1_NUMBCO  	            // BACKUP DO NOSSO NUMERO
			SE1->E1_BKPPORT  := ALLTRIM(MV_PAR19)               // BANCO SELECIONADO NOS PARAMETROS
			SE1->E1_BKPAGEN  := ALLTRIM(MV_PAR20)               // AGENCIA SELECIONADA NOS PARAMETROS
			SE1->E1_BKPCONT  := ALLTRIM(MV_PAR21)               // CONTA SELECIONADA NOS PARAMETROS
			SE1->E1_DATABO   := dDataBase                 // DATA DA GERACAO DO BOLETO
			SE1->E1_HORABO   := TIME()                          // HORA DA GERACAO DO BOLETO
			MsUnlock()
		EndIf

		aAdd(__aDadBco, Alltrim(SA6->A6_COD))     			// [1]Numero do Banco
		aAdd(__aDadBco, Alltrim(SA6->A6_NOME))    			// [2]Nome do Banco
		aAdd(__aDadBco, Left(Alltrim(SA6->A6_AGENCIA),4)) 	// [3]Agência
		aAdd(__aDadBco, Alltrim(SA6->A6_NUMCON))   			// [4]Conta Corrente
		aAdd(__aDadBco, Alltrim(SA6->A6_DVCTA))  				// [5]Dígito da conta corrente
		aAdd(__aDadBco, Alltrim(__cCartei))     				// [6]Codigo da Carteira

		If Empty(SA1->A1_ENDCOB)
			__aDadSac := {	AllTrim(SA1->A1_NOME)           						 							,;      	// [1]Razão Social
								AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           								,;      	// [2]Código
								AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_COMPLEM)+"-"+AllTrim(SA1->A1_BAIRRO)	,;      	// [3]Endereço
								AllTrim(SA1->A1_MUN )                            								,;	  		// [4]Cidade
								SA1->A1_EST                                      								,;   		// [5]Estado
								SA1->A1_CEP                                      								,;      	// [6]CEP
								SA1->A1_CGC										 								,;			// [7]CGC
								SA1->A1_PESSOA									  				 }			// [8]PESSOA
		Else
			__aDadSac := { AllTrim(SA1->A1_NOME)              						,;   		// [1]Razão Social
								AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
								AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
								AllTrim(SA1->A1_MUNC)	                           ,;  	 	// [4]Cidade
								SA1->A1_ESTC	                                    ,;   		// [5]Estado
								SA1->A1_CEPC                                       ,;   		// [6]CEP
								SA1->A1_CGC														,;	  		// [7]CGC
								SA1->A1_PESSOA										 			 }	  		// [8]PESSOA
		Endif

		__nVlrAbt := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

		//Parte do Nosso Numero. Sao 8 digitos para identificar o titulo
		__cNroDoc := SubStr(E1_NUMBCO,1,8)

		//Monta codigo de barras
		__cMntBar := fLinhaDig( __aDadBco[1]      	,; // Numero do Banco
										__cMoedas            ,; // Codigo da Moeda
										__aDadBco[6]      	,;	// Codigo da Carteira
										__aDadBco[3]      	,; // Codigo da Agencia
										__aDadBco[4]      	,;	// Codigo da Conta
										__aDadBco[5]      	,;	// DV da Conta
										(E1_VALOR-__nVlrAbt) ,;	// Valor do Titulo
										E1_VENCTO           	,;	// Data de Vencimento do Titulo
										__cNroDoc             )	// Numero do Documento no Contas a Receber


		__aDadTit := {	AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,; // [1] Número do título
							E1_EMISSAO                          ,;	// [2] Data da emissão do título
							dDataBase                    			,;	// [3] Data da emissão do boleto
							E1_VENCTO                           ,;	// [4] Data do vencimento
							(E1_VALOR - __nVlrAbt)              ,;	// [5] Valor do título
							__cMntBar[3]                        ,;	// [6] Nosso número (Ver fórmula para calculo)
							E1_PREFIXO                          ,;	// [7] Prefixo da NF
							E1_TIPO	                          	,; // [8] Tipo do Titulo
							E1_OBSBOL                            } // [9] Observacao do Boleto

		Impress(__oPrnBol,__aInfEmp,__aDadTit,__aDadBco,__aDadSac,__aBolTxt,__cMntBar)
	EndIf
	dbSkip()
	IncProc()
End

__oPrnBol:EndPage() // Finaliza a página
__oPrnBol:Preview() // Visualiza antes de imprimir

Return Nil

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPRESS  ºAutor  ³Microsiga           º Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos dados do boleto em modo grafico              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Impress(__oPrnBol,__aInfEmp,__aDadTit,__aDadBco,__aDadSac,__aBolTxt,__cMntBar)

Local oFont8
Local oFont11c
Local oFont10
Local oFont14
Local oFont16n
Local oFont15
Local oFont14n
Local oFont24
Local nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.t.,.f.,5,.t.,5,.t.,.f.)
oFont11c := TFont():New("Courier New",9,11,.t.,.t.,5,.t.,5,.t.,.f.)
oFont11  := TFont():New("Arial",9,11,.t.,.t.,5,.t.,5,.t.,.f.)
oFont9   := TFont():New("Arial",9,8,.t.,.t.,5,.t.,5,.t.,.f.)
oFont10  := TFont():New("Arial",9,10,.t.,.t.,5,.t.,5,.t.,.f.)
oFont14  := TFont():New("Arial",9,14,.t.,.t.,5,.t.,5,.t.,.f.)
oFont20  := TFont():New("Arial",9,20,.t.,.t.,5,.t.,5,.t.,.f.)
oFont21  := TFont():New("Arial",9,21,.t.,.t.,5,.t.,5,.t.,.f.)
oFont16n := TFont():New("Arial",9,16,.t.,.f.,5,.t.,5,.t.,.f.)
oFont15  := TFont():New("Arial",9,15,.t.,.t.,5,.t.,5,.t.,.f.)
oFont15n := TFont():New("Arial",9,14,.t.,.f.,5,.t.,5,.t.,.f.)
oFont14n := TFont():New("Arial",9,14,.t.,.f.,5,.t.,5,.t.,.f.)
oFont24  := TFont():New("Arial",9,24,.t.,.t.,5,.t.,5,.t.,.f.)

__oPrnBol:StartPage()   // Inicia uma nova página
// PRIMEIRA PARTE
__nNumLin := 0

__oPrnBol:Line(__nNumLin+0150,500,__nNumLin+0070, 500)
__oPrnBol:Line(__nNumLin+0150,710,__nNumLin+0070, 710)

__oPrnBol:Say(__nNumLin+0084,100,__aDadBco[2],oFont11 )	      // [2]Nome do Banco
__oPrnBol:Say(__nNumLin+0075,513,__aDadBco[1]+"-7",oFont21 )	// [1]Numero do Banco

__oPrnBol:Say(__nNumLin+0084,1900,"Comprovante de Entrega",oFont10)
__oPrnBol:Line(__nNumLin+0150,100,__nNumLin+0150,2300)

__oPrnBol:Say(__nNumLin+0150,100 ,"Beneficiario",oFont8)
__oPrnBol:Say(__nNumLin+0165,320 ,"FLAMIN MINERACAO LTDA / CNPJ 68.248.210/0001-37",oFont8)
__oPrnBol:Say(__nNumLin+0205,320 ,"ROD.GOV.MARIO COVAS JR,KM 1,5 - LINDOIA - SP",oFont8)

__oPrnBol:Say(__nNumLin+0150,1060,"Agência/Código do Beneficiário",oFont8)
__oPrnBol:Say(__nNumLin+0200,1060,__aDadBco[3]+"/"+__aDadBco[4]+"-"+__aDadBco[5],oFont10)

__oPrnBol:Say(__nNumLin+0150,1510,"Nro.Documento",oFont8)
__oPrnBol:Say(__nNumLin+0200,1510,__aDadTit[7]+__aDadTit[1],oFont10) //Prefixo+Numero+Parcela

__oPrnBol:Say(__nNumLin+0250,100 ,"Pagador",oFont8)
__oPrnBol:Say(__nNumLin+0300,100 ,__aDadSac[1],oFont9) //Nome

__oPrnBol:Say(__nNumLin+0250,1060,"Vencimento",oFont8)
__oPrnBol:Say(__nNumLin+0300,1080,StrZero(Day(__aDadTit[4]),2)+"/"+StrZero(Month(__aDadTit[4]),2)+"/"+Right(Str(Year(__aDadTit[4])),4),oFont10)

__oPrnBol:Say(__nNumLin+0250,1510,"Valor do Documento",oFont8)
__oPrnBol:Say(__nNumLin+0300,1550,AllTrim(Transform(__aDadTit[5],"@E 999,999,999.99")),oFont10)

__oPrnBol:Say(__nNumLin+0400,0100,"Recebi(emos) o bloqueto/título com as caracteristicas acima.",oFont8)
__oPrnBol:Say(__nNumLin+0350,1060,"Data",oFont8)
__oPrnBol:Say(__nNumLin+0350,1410,"Assinatura",oFont8)
__oPrnBol:Say(__nNumLin+0450,1060,"Data",oFont8)
__oPrnBol:Say(__nNumLin+0450,1410,"Entregador",oFont8)

__oPrnBol:Line(__nNumLin+0250, 100,__nNumLin+0250,1900 )
__oPrnBol:Line(__nNumLin+0350, 100,__nNumLin+0350,1900 )
__oPrnBol:Line(__nNumLin+0450,1050,__nNumLin+0450,1900 )
__oPrnBol:Line(__nNumLin+0550, 100,__nNumLin+0550,2300 )

__oPrnBol:Line(__nNumLin+0550,1050,__nNumLin+0150,1050 )
__oPrnBol:Line(__nNumLin+0550,1400,__nNumLin+0350,1400 )
__oPrnBol:Line(__nNumLin+0350,1500,__nNumLin+0150,1500 )
__oPrnBol:Line(__nNumLin+0550,1900,__nNumLin+0150,1900 )

__oPrnBol:Say(__nNumLin+0165,1910,"(  )Mudou-se"                ,oFont8)
__oPrnBol:Say(__nNumLin+0205,1910,"(  )Ausente"                 ,oFont8)
__oPrnBol:Say(__nNumLin+0245,1910,"(  )Não existe nº indicado"  ,oFont8)
__oPrnBol:Say(__nNumLin+0285,1910,"(  )Recusado"                ,oFont8)
__oPrnBol:Say(__nNumLin+0325,1910,"(  )Não procurado"           ,oFont8)
__oPrnBol:Say(__nNumLin+0365,1910,"(  )Endereço insuficiente"   ,oFont8)
__oPrnBol:Say(__nNumLin+0405,1910,"(  )Desconhecido"            ,oFont8)
__oPrnBol:Say(__nNumLin+0445,1910,"(  )Falecido"                ,oFont8)
__oPrnBol:Say(__nNumLin+0485,1910,"(  )Outros(anotar no verso)" ,oFont8)

// SEGUNDA PARTE
__nNumLin := 0

__oPrnBol:Line(__nNumLin+0710,100,__nNumLin+0710,2300)
__oPrnBol:Line(__nNumLin+0710,500,__nNumLin+0630, 500)
__oPrnBol:Line(__nNumLin+0710,710,__nNumLin+0630, 710)

__oPrnBol:Say(__nNumLin+0644,100,__aDadBco[2],oFont11 )		   // [2]Nome do Banco
__oPrnBol:Say(__nNumLin+0635,513,__aDadBco[1]+"-7",oFont21 )	// [1]Numero do Banco
__oPrnBol:Say(__nNumLin+0644,1800,"Recibo do Pagador",oFont10)

__oPrnBol:Line(__nNumLin+0810,100,__nNumLin+0810,2300 )
__oPrnBol:Line(__nNumLin+0910,100,__nNumLin+0910,2300 )
__oPrnBol:Line(__nNumLin+0980,100,__nNumLin+0980,2300 )
__oPrnBol:Line(__nNumLin+1050,100,__nNumLin+1050,2300 )

__oPrnBol:Line(__nNumLin+0910,500,__nNumLin+1050,500)
__oPrnBol:Line(__nNumLin+0980,750,__nNumLin+1050,750)
__oPrnBol:Line(__nNumLin+0910,1000,__nNumLin+1050,1000)
__oPrnBol:Line(__nNumLin+0910,1300,__nNumLin+0980,1300)
__oPrnBol:Line(__nNumLin+0910,1480,__nNumLin+1050,1480)

__oPrnBol:Say(__nNumLin+0710,100 ,"Local de Pagamento",oFont8)
__oPrnBol:Say(__nNumLin+0725,400 ,"Ate o vencimento pague preferencialmente no ITAU",oFont10)
__oPrnBol:Say(__nNumLin+0765,400 ,"Apos o vencimento pague somente no ITAU",oFont10)

__oPrnBol:Say(__nNumLin+0710,1810,"Vencimento",oFont8)
__cString := StrZero(Day(__aDadTit[4]),2) +"/"+ StrZero(Month(__aDadTit[4]),2) +"/"+ Right(Str(Year(__aDadTit[4])),4)
__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+0750,__nColuna,__cString,oFont11c)

__oPrnBol:Say(__nNumLin+0810,100 ,"Beneficiario",oFont8)
__oPrnBol:Say(__nNumLin+0825,330 ,"FLAMIN MINERACAO LTA / CNPJ 68.248.210/0001-37",oFont8)
__oPrnBol:Say(__nNumLin+0865,330 ,"ROD.GOV.MARIO COVAS JR,KM 1,5 - LINDOIA - SP ",oFont8)

__oPrnBol:Say(__nNumLin+0810,1810,"Agência/Código do Beneficiário",oFont8)
__cString := Alltrim(__aDadBco[3]+"/"+__aDadBco[4]+"-"+__aDadBco[5])
__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+0850,__nColuna,__cString,oFont11c)

__oPrnBol:Say(__nNumLin+0910,100 ,"Data do Documento",oFont8)
__oPrnBol:Say(__nNumLin+0940,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4),oFont10)

__oPrnBol:Say(__nNumLin+0910,505 ,"Nro.Documento",oFont8)
__oPrnBol:Say(__nNumLin+0940,605 ,__aDadTit[7]+__aDadTit[1],oFont10) //Prefixo+Numero+Parcela

__oPrnBol:Say(__nNumLin+0910,1005,"Espécie Doc.",oFont8)
__oPrnBol:Say(__nNumLin+0940,1050,__aDadTit[8],oFont10) //Tipo do Titulo

__oPrnBol:Say(__nNumLin+0910,1305,"Aceite",oFont8)
__oPrnBol:Say(__nNumLin+0940,1400,"N",oFont10)

__oPrnBol:Say(__nNumLin+0910,1485,"Data do Processamento",oFont8)
__oPrnBol:Say(__nNumLin+0940,1550,StrZero(Day(__aDadTit[3]),2) +"/"+ StrZero(Month(__aDadTit[3]),2) +"/"+ Right(Str(Year(__aDadTit[3])),4),oFont10) // Data impressao

__oPrnBol:Say(__nNumLin+0910,1810,"Nosso Número",oFont8)
__cString := Alltrim(SubStr(__aDadTit[6],1,3)+"/"+AllTrim(SE1->E1_NUMBCO))

__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+0940,__nColuna,__cString,oFont11c)

__oPrnBol:Say(__nNumLin+0980,100 ,"Uso do Banco",oFont8)

__oPrnBol:Say(__nNumLin+0980,505 ,"Carteira",oFont8)
__oPrnBol:Say(__nNumLin+1010,555 ,__aDadBco[6],oFont10)

__oPrnBol:Say(__nNumLin+0980,755 ,"Espécie",oFont8)
__oPrnBol:Say(__nNumLin+1010,805 ,"R$",oFont10)

__oPrnBol:Say(__nNumLin+0980,1005,"Quantidade",oFont8)
__oPrnBol:Say(__nNumLin+0980,1485,"Valor",oFont8)

__oPrnBol:Say(__nNumLin+0980,1810,"Valor do Documento",oFont8)
__cString := Alltrim(Transform(__aDadTit[5],"@E 99,999,999.99"))
__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+1010,__nColuna,__cString ,oFont11c)

__oPrnBol:Say(__nNumLin+1050,100 ,"Instruções de responsabilidade do beneficiário. Qualquer dúvida sobre este boleto, contate o beneficiário.",oFont8)
__oPrnBol:Say(__nNumLin+1150,100 ,__aBolTxt[1]+" "+AllTrim(Transform(((__aDadTit[5]*(4.50/30))/100),"@E 99,999.99"))+" AO DIA"  ,oFont10)
__oPrnBol:Say(__nNumLin+1200,100 ,__aBolTxt[2]+StrZero(Day(__aDadTit[4]+5),2) +"/"+ StrZero(Month(__aDadTit[4]+5),2) +"/"+ Right(Str(Year(__aDadTit[4]+5)),4),oFont10)
__oPrnBol:Say(__nNumLin+1350,100 ,"ATENCAO : SR. CAIXA NÃO RECEBER APOS "+StrZero(Day(__aDadTit[4]+4),2) +"/"+ StrZero(Month(__aDadTit[4]+4),2) +"/"+ Right(Str(Year(__aDadTit[4]+4)),4) ,oFont14)
__oPrnBol:Say(__nNumLin+1250,100 ,SubStr(__aDadTit[9],1,72),oFont10)
__oPrnBol:Say(__nNumLin+1300,100 ,SubStr(__aDadTit[9],73,72),oFont10)

__oPrnBol:Say(__nNumLin+1050,1810,"(-)Desconto/Abatimento",oFont8)
__oPrnBol:Say(__nNumLin+1120,1810,"(-)Outras Deduções",oFont8)
__oPrnBol:Say(__nNumLin+1190,1810,"(+)Mora/Multa",oFont8)
__oPrnBol:Say(__nNumLin+1260,1810,"(+)Outros Acréscimos",oFont8)
__oPrnBol:Say(__nNumLin+1330,1810,"(=)Valor Cobrado",oFont8)

__oPrnBol:Say(__nNumLin+1400,100 ,"Pagador",oFont8)
__oPrnBol:Say(__nNumLin+1430,400 ,__aDadSac[1]+" ("+__aDadSac[2]+")",oFont10)
__oPrnBol:Say(__nNumLin+1483,400 ,__aDadSac[3],oFont10)
__oPrnBol:Say(__nNumLin+1536,400 ,__aDadSac[6]+"    "+__aDadSac[4]+" - "+__aDadSac[5],oFont10)

if __aDadSac[8] = "J"
	__oPrnBol:Say(__nNumLin+1589,400 ,"CNPJ: "+TRANSFORM(__aDadSac[7],"@R 99.999.999/9999-99"),oFont10)
Else
	__oPrnBol:Say(__nNumLin+1589,400 ,"CPF: "+TRANSFORM(__aDadSac[7],"@R 999.999.999-99"),oFont10)
EndIf

__oPrnBol:Say(__nNumLin+1589,1850,SubStr(__aDadTit[6],1,3)+SubStr(__aDadTit[6],4),oFont10)

__oPrnBol:Say(__nNumLin+1605,100 ,"Sacador/Avalista",oFont8)
__oPrnBol:Say(__nNumLin+1645,1500,"Autenticação Mecânica",oFont8)

__oPrnBol:Line(__nNumLin+0710,1800,__nNumLin+1400,1800 )
__oPrnBol:Line(__nNumLin+1120,1800,__nNumLin+1120,2300 )
__oPrnBol:Line(__nNumLin+1190,1800,__nNumLin+1190,2300 )
__oPrnBol:Line(__nNumLin+1260,1800,__nNumLin+1260,2300 )
__oPrnBol:Line(__nNumLin+1330,1800,__nNumLin+1330,2300 )
__oPrnBol:Line(__nNumLin+1400,100 ,__nNumLin+1400,2300 )
__oPrnBol:Line(__nNumLin+1640,100 ,__nNumLin+1640,2300 )

// TERCEIRA PARTE
__nNumLin := 0

For nI := 100 to 2300 step 50
	__oPrnBol:Line(__nNumLin+1880, nI, __nNumLin+1880, nI+30)
Next nI

__oPrnBol:Line(__nNumLin+2000,100,__nNumLin+2000,2300)
__oPrnBol:Line(__nNumLin+2000,500,__nNumLin+1920, 500)
__oPrnBol:Line(__nNumLin+2000,710,__nNumLin+1920, 710)

__oPrnBol:Say(__nNumLin+1934,100,__aDadBco[2],oFont11 )			//	[2]Nome do Banco
__oPrnBol:Say(__nNumLin+1925,513,__aDadBco[1]+"-7",oFont21 )	//	[1]Numero do Banco
__oPrnBol:Say(__nNumLin+1934,755,__cMntBar[2],oFont15n)			//	Linha Digitavel do Codigo de Barras

__oPrnBol:Line(__nNumLin+2100,100,__nNumLin+2100,2300)
__oPrnBol:Line(__nNumLin+2200,100,__nNumLin+2200,2300)
__oPrnBol:Line(__nNumLin+2270,100,__nNumLin+2270,2300)
__oPrnBol:Line(__nNumLin+2340,100,__nNumLin+2340,2300)

__oPrnBol:Line(__nNumLin+2200,500 ,__nNumLin+2340,500 )
__oPrnBol:Line(__nNumLin+2270,750 ,__nNumLin+2340,750 )
__oPrnBol:Line(__nNumLin+2200,1000,__nNumLin+2340,1000)
__oPrnBol:Line(__nNumLin+2200,1300,__nNumLin+2270,1300)
__oPrnBol:Line(__nNumLin+2200,1480,__nNumLin+2340,1480)

__oPrnBol:Say(__nNumLin+2000,100 ,"Local de Pagamento",oFont8)
__oPrnBol:Say(__nNumLin+2015,400 ,"Ate o vencimento pague preferencialmente no ITAU",oFont10)
__oPrnBol:Say(__nNumLin+2055,400 ,"Apos o vencimento pague somente no ITAU",oFont10)

__oPrnBol:Say(__nNumLin+2000,1810,"Vencimento",oFont8)
__cString := StrZero(Day(__aDadTit[4]),2) +"/"+ StrZero(Month(__aDadTit[4]),2) +"/"+ Right(Str(Year(__aDadTit[4])),4)
__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+2040,__nColuna,__cString,oFont11c)

__oPrnBol:Say(__nNumLin+2100,100 ,"Beneficiario",oFont8)
__oPrnBol:Say(__nNumLin+2125,330 ,"FLAMIN MINERACAO LTA / CNPJ 68.248.210/0001-37",oFont8)
__oPrnBol:Say(__nNumLin+2165,330 ,"ROD.GOV.MARIO COVAS JR,KM 1,5 - LINDOIA - SP ",oFont8)

__oPrnBol:Say(__nNumLin+2100,1810,"Agência/Código do Beneficiário",oFont8)
__cString := Alltrim(__aDadBco[3]+"/"+__aDadBco[4]+"-"+__aDadBco[5])
__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+2140,__nColuna,__cString ,oFont11c)

__oPrnBol:Say(__nNumLin+2200,100 ,"Data do Documento",oFont8)
__oPrnBol:Say(__nNumLin+2230,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4), oFont10)

__oPrnBol:Say(__nNumLin+2200,505 ,"Nro.Documento",oFont8)
__oPrnBol:Say(__nNumLin+2230,605 ,__aDadTit[7]+__aDadTit[1],oFont10) //Prefixo +Numero+Parcela

__oPrnBol:Say(__nNumLin+2200,1005,"Espécie Doc.",oFont8)
__oPrnBol:Say(__nNumLin+2230,1050,__aDadTit[8],oFont10) //Tipo do Titulo

__oPrnBol:Say(__nNumLin+2200,1305,"Aceite",oFont8)
__oPrnBol:Say(__nNumLin+2230,1400,"N",oFont10)

__oPrnBol:Say(__nNumLin+2200,1485,"Data do Processamento",oFont8)
__oPrnBol:Say(__nNumLin+2230,1550,StrZero(Day(__aDadTit[3]),2) +"/"+ StrZero(Month(__aDadTit[3]),2) +"/"+ Right(Str(Year(__aDadTit[3])),4)                               ,oFont10) // Data impressao

__oPrnBol:Say(__nNumLin+2200,1810,"Nosso Número",oFont8)
__cString := Alltrim(SubStr(__aDadTit[6],1,3)+"/"+AllTrim(SE1->E1_NUMBCO))

__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+2230,__nColuna,__cString,oFont11c)

__oPrnBol:Say(__nNumLin+2270,100 ,"Uso do Banco",oFont8)

__oPrnBol:Say(__nNumLin+2270,505 ,"Carteira",oFont8)
__oPrnBol:Say(__nNumLin+2300,555 ,__aDadBco[6],oFont10)

__oPrnBol:Say(__nNumLin+2270,755 ,"Espécie",oFont8)
__oPrnBol:Say(__nNumLin+2300,805 ,"R$",oFont10)

__oPrnBol:Say(__nNumLin+2270,1005,"Quantidade",oFont8)
__oPrnBol:Say(__nNumLin+2270,1485,"Valor",oFont8)

__oPrnBol:Say(__nNumLin+2270,1810,"Valor do Documento",oFont8)
__cString := Alltrim(Transform(__aDadTit[5],"@E 99,999,999.99"))
__nColuna := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(__nNumLin+2300,__nColuna,__cString,oFont11c)

__oPrnBol:Say(__nNumLin+2340,100 ,"Instruções de responsabilidade do beneficiário. Qualquer dúvida sobre este boleto, contate o beneficiário.",oFont8)
__oPrnBol:Say(__nNumLin+2440,100 ,__aBolTxt[1]+" "+AllTrim(Transform(((__aDadTit[5]*(4.50/30))/100),"@E 99,999.99"))+" AO DIA" ,oFont10)
__oPrnBol:Say(__nNumLin+2490,100 ,__aBolTxt[2]+StrZero(Day(__aDadTit[4]+5),2) +"/"+ StrZero(Month(__aDadTit[4]+5),2) +"/"+ Right(Str(Year(__aDadTit[4]+5)),4) ,oFont10)
__oPrnBol:Say(__nNumLin+2630,100 ,"ATENCAO : SR. CAIXA NÃO RECEBER APOS "+StrZero(Day(__aDadTit[4]+4),2) +"/"+ StrZero(Month(__aDadTit[4]+4),2) +"/"+ Right(Str(Year(__aDadTit[4]+4)),4) ,oFont14)

__oPrnBol:Say(__nNumLin+2540,100 ,SubStr(__aDadTit[9],1,72),oFont10)
__oPrnBol:Say(__nNumLin+2590,100 ,SubStr(__aDadTit[9],73,72),oFont10)

__oPrnBol:Say(__nNumLin+2340,1810,"(-)Desconto/Abatimento",oFont8)
__oPrnBol:Say(__nNumLin+2410,1810,"(-)Outras Deduções",oFont8)
__oPrnBol:Say(__nNumLin+2480,1810,"(+)Mora/Multa",oFont8)
__oPrnBol:Say(__nNumLin+2550,1810,"(+)Outros Acréscimos",oFont8)
__oPrnBol:Say(__nNumLin+2620,1810,"(=)Valor Cobrado",oFont8)

__oPrnBol:Say(__nNumLin+2690,100 ,"Pagador",oFont8)
__oPrnBol:Say(__nNumLin+2700,400 ,__aDadSac[1]+" ("+__aDadSac[2]+")",oFont10)

if __aDadSac[8] = "J"
	__oPrnBol:Say(__nNumLin+2700,1750,"CNPJ: "+TRANSFORM(__aDadSac[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	__oPrnBol:Say(__nNumLin+2700,1750,"CPF: "+TRANSFORM(__aDadSac[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

__oPrnBol:Say(__nNumLin+2753,400 ,__aDadSac[3],oFont10)
__oPrnBol:Say(__nNumLin+2806,400 ,__aDadSac[6]+"    "+__aDadSac[4]+" - "+__aDadSac[5],oFont10) // CEP+Cidade+Estado
__oPrnBol:Say(__nNumLin+2806,1750,SubStr(__aDadTit[6],1,3)+SubStr(__aDadTit[6],4),oFont10)

__oPrnBol:Say(__nNumLin+2815,100 ,"Sacador/Avalista",oFont8)
__oPrnBol:Say(__nNumLin+2855,1500,"Autenticação Mecânica - Ficha de Compensação",oFont8)

__oPrnBol:Line(__nNumLin+2000,1800,__nNumLin+2690,1800 )
__oPrnBol:Line(__nNumLin+2410,1800,__nNumLin+2410,2300 )
__oPrnBol:Line(__nNumLin+2480,1800,__nNumLin+2480,2300 )
__oPrnBol:Line(__nNumLin+2550,1800,__nNumLin+2550,2300 )
__oPrnBol:Line(__nNumLin+2620,1800,__nNumLin+2620,2300 )
__oPrnBol:Line(__nNumLin+2690,100 ,__nNumLin+2690,2300 )

__oPrnBol:Line(__nNumLin+2850,100,__nNumLin+2850,2300  )

MSBAR("INT25",25.1,1,__cMntBar[1],__oPrnBol,.f.,Nil,Nil,0.022,1.5,Nil,Nil,"A",.f.) //datasupri

__oPrnBol:EndPage() // Finaliza a página
Return Nil

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FLINHADIG ºAutor  ³Microsiga           º Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtenção da linha digitavel/codigo de barras               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function fLinhaDig (__cCodBco ,; // Codigo do Banco (341)
									__cCodMod ,; // Codigo da Moeda (9)
									__cCodCar ,; // Codigo da Carteira
									__cCodAge ,; // Codigo da Agencia
									__cCodCta ,; // Codigo da Conta
									__cDigCta ,; // Digito verificadorÁ da Conta
									__nVlrTit ,; // Valor do Titulo
									__dDtaVct ,; // Data de vencimento do titulo
									__cNroDoc  ) // Numero do Documento Ref ao Contas a Receber

//declaracao de variaveis
Local __cVlrFin := StrZero((__nVlrTit*100),10)
//Local __cFtrVct := StrZero((__dDtaVct - CtoD("07/10/97")),4)
Local __cFtrVct := StrZero(__dDtaVct - Iif(__dDtaVct >= Ctod('22/02/25'), CtoD('29/05/22'), CtoD("07/10/97")), 4)
Local __cCodBar := Replicate("0",43)
Local __cCampo1 := Replicate("0",05)+"."+Replicate("0",05)
Local __cCampo2 := Replicate("0",05)+"."+Replicate("0",06)
Local __cCampo3 := Replicate("0",05)+"."+Replicate("0",06)
Local __cCampo4 := Replicate("0",01)
Local __cCampo5 := Replicate("0",14)
Local __cTmpTmp := ""
Local __cNosNum := SubStr(AllTrim(SE1->E1_NUMBCO),1,8) // Nosso numero
Local __cSE1Bco := SubStr(AllTrim(SE1->E1_NUMBCO),1,9) // Nosso numero
Local __cSE1Num := AllTrim(SE1->E1_NUM) // Nosso numero
Local __cDigito := "" // Digito verificador dos campos
Local __cLinDig := ""

// Definicao do NOSSO NUMERO
If At("-",__cCodCta) > 0
	__cDigito := Right(AllTrim(__cCodCta),1)
	__cCodCta := AllTrim(Str(Val(Left(__cCodCta,At('-',__cCodCta)-1) + __cDigito)))
Else
	__cCodCta := AllTrim(Str(Val(__cCodCta)))
Endif
__cNosNum := __cCodCar + SubStr(AllTrim(SE1->E1_NUMBCO),1,9)

// Definicao do CODIGO DE BARRAS
__cTmpTmp := 	Alltrim(__cCodBco)            + ; // 01 a 03
					Alltrim(__cCodMod)            + ; // 04 a 04
					Alltrim(__cFtrVct)            + ; // 06 a 09
					Alltrim(__cVlrFin)          	+ ; // 10 a 19
					Alltrim(__cCodCar)            + ; // 20 a 22
					SubStr(SE1->E1_NUMBCO,1,8) 	+ ; // 23 A 30
					SubStr(SE1->E1_NUMBCO,9,1)    + ; // 31 a 31
					Alltrim(__cCodAge)            + ; // 32 a 35
					Left(Alltrim(__cCodCta),5)    + ; // 36 a 40
					Alltrim(__cDigCta)       		+ ; // 41 a 41
					"000"                             // 42 a 44
__cDigCBr := Alltrim(Str(Modulo11(__cTmpTmp)))	// Digito Verificador CodBarras
__cCodBar := SubStr(__cTmpTmp,1,4) + __cDigCBr + SubStr(__cTmpTmp,5)

// Definicao da LINHA DIGITAVEL (Representacao Numerica)
// Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
// AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

//CAMPO 1:
//AAA = Codigo do banco na Camara de Compensacao
//B = Codigo da moeda, sempre 9
//CCC = Codigo da Carteira de Cobranca
//DD = Dois primeiros digitos no nosso numero
//X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
__cTmpTmp := __cCodBco + __cCodMod + __cCodCar + SubStr(__cSE1Bco,1,2)
__cDigTmp := Alltrim(Str(Modulo10(__cTmpTmp)))
__cCampo1 := SubStr(__cTmpTmp,1,5) + '.' + Alltrim(SubStr(__cTmpTmp,6)) + __cDigTmp + Space(2)

//CAMPO 2:
//DDDDDD= Restante do Nosso Número
//E = DAC do campo [Agência/Conta/Carteira/ Nosso Número]
//FFF = Três primeiros números que identificam a Agência
//Y = DAC que amarra o campo 2 (Anexo 3)
__cTmpTmp := SubStr(__cSE1Bco,3,7) + SubStr(__cCodAge,1,3) //+ SubStr(__cCodAge,1,3)
__cDigTmp := Alltrim(Str(Modulo10(__cTmpTmp)))
__cCampo2 := SubStr(__cTmpTmp,1,5) + '.' + SubStr(__cTmpTmp,6) + __cDigTmp + Space(3)

//CAMPO 3:
//F = Restante do número que identifica a agência
//GGGGGG = Número da conta corrente + DAC
//HHH = Zeros ( Não utilizado )
//Z = DAC que amarra o campo 3 (Anexo 3)
__cTmpTmp := SubStr(__cCodAge,4,1) + Left(__cCodCta,5) + __cDigCta + "000"
__cDigTmp := Alltrim(Str(Modulo10(__cTmpTmp)))
__cCampo3 := SubStr(__cTmpTmp,1,5) + '.' + SubStr(__cTmpTmp,6) + __cDigTmp + Space(2)

//(341)(9)(1.09)(00)(8) (00004.2)(8)(101)(0) (7)(5884.4)(4)(000)(1) (1) (63630000019188)
//CAMPO 4:
//K = DAC do Codigo de Barras
__cCampo4 := __cDigCBr + Space(2)

//CAMPO 5:
//UUUU = Fator de Vencimento
//VVVVVVVVVV = Valor do Titulo
__cCampo5 := __cFtrVct + StrZero((__nVlrTit * 100),14 - Len(__cFtrVct))
__cLinDig := __cCampo1 + __cCampo2 + __cCampo3 + __cCampo4 + __cCampo5

Return {__cCodBar, __cLinDig, __cNosNum}

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MODULO10 ºAutor  ³Microsiga           º Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cálculo do Modulo 10 para obtenção do DV dos campos do CB  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function Modulo10(__cString)

//declaracao de variaveis

Local __cQtdStr,__nCalDig,__nCaract := 0
Local __lPriCar := .f.

__cQtdStr := Len(__cString)
__lPriCar := .t.
__nCalDig := 0

While __cQtdStr > 0
	__nCalcul := Val(SubStr(__cString, __cQtdStr, 1))
	If (__lPriCar)
		__nCalcul := __nCalcul * 2
		If __nCalcul > 9
			__nCalcul := __nCalcul - 9
		End
	End
	__nCalDig := __nCalDig + __nCalcul
	__cQtdStr := __cQtdStr - 1
	__lPriCar := !__lPriCar
End

__nCalDig := 10 - (Mod(__nCalDig,10))

If __nCalDig = 10
	__nCalDig := 0
End

Return __nCalDig

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MODULO11 ºAutor  ³Microsiga           º Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cálculo do Modulo 10 para obtenção do DV dos campos do CB  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function Modulo11(__cString)

Local __cQtdStr, __nCalDig, __nCalcul := 0

__cQtdStr := Len(__cString)
__nCalDig := 0
__nCalcul := 1

// Some o resultado de cada produto efetuado e determine o total como (__nCalDig);
While __cQtdStr > 0
	__nCalcul := __nCalcul + 1
	__nCalDig := __nCalDig + (Val(SubStr(__cString, __cQtdStr, 1)) * __nCalcul)
	If __nCalcul = 9
		__nCalcul := 1
	End
	__cQtdStr := __cQtdStr - 1
End

// DAC = 11 - Mod 11(D)
__nCalDig := 11 - (mod(__nCalDig,11))
// OBS: Se o resultado desta for igual a 0, 1, 10 ou 11, considere DAC = 1.
If (__nCalDig == 0 .or. __nCalDig == 1 .or. __nCalDig == 10 .or. __nCalDig == 11)
	__nCalDig := 1
End

Return __nCalDig
