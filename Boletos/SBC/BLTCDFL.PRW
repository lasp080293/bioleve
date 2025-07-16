#Include 'rwmake.ch'
#Include 'protheus.ch'

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北砅rograma  矪LTCDFL   ?Autor ?Claudinei M. Gomes    ?Data ?8/01/2015潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪拍哪哪哪穆哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矻ocacao   ?Fladis           矯ontato ? Alexandre                     潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪聊哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北矰escricao ?Rotina p/ Geracao Boleto Banco do BRasil com Cod. Barras   潮?
北媚哪哪哪哪牧哪穆哪哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北矨nalista Resp.? Data  ?       Manutencao Efetuada                    潮?
北媚哪哪哪哪哪哪呐哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北矯laudinei     ?5/01/15?Ajustes especificos                           潮?
北矯laudinei     ?1/01/15?Ajuste nos Filtros                            潮?
北矯laudinei     ?8/01/15?Ajustes conforme orientacao apos validacao BB 潮?
北?             ? /  /  ?                                              潮?
北滥哪哪哪哪哪哪牧哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
User Function BLTCDFL()

oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )

#define DS_MODALFRAME   128
DEFINE MsDialog oDlg1 From 0,0 To 350,300 Title "EMISS肙 DE BOLETOS" Pixel Style DS_MODALFRAME // Cria Dialog sem o bot鉶 de Fechar.
//oDlg1:lTEscClose := .F.

oSay1      := TSay():New( 05,25,{||"EMISS肙 DE BOLETOS"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oSay1      := TSay():New( 20,45,{||"      BANCO       "},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,012)
oTBitmap1  := TBitmap():New(45,25,150,150,,"LOGO_BB.PNG",.T.,oDlg1,,,.F.,.F.,,,.F.,,.T.,,.F.)

oBtn1      := TButton():New( 150,025,"OK",oDlg1,{|| OK()},035,015,,oFont2,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 150,100,"Cancelar",oDlg1,{|| oDlg1:End()},035,015,,oFont2,,.T.,,"",,,,.F. )

ACTIVATE DIALOG oDlg1 CENTERED
Return(.T.)


Static Function OK()


// Local	__aPrgSX1 := {}
Private __lExecut := .f.
Private __cIdxNam := ''
Private __cIdxKey := ''
Private __cFilter := ''
//Private __cCartei	:= '17-019' //antes
Private __cCartei	:= '17-035' //novo

Tamanho   := 'M'
Titulo    := 'Impressao de Boleto com Codigo de Barras-Banco do Brasil'
cDesc1    := 'Este programa destina-se a impressao do Boleto com Codigo de Barras.'
cDesc2    := ''
cDesc3    := ''
cString   := 'SE1'
If SM0->M0_CODIGO $ "12"
__cNrCNPJ := '68.248.210/0002-18'
ELSE
__cNrCNPJ := '68.248.210/0001-37'
ENDIF
wnrel     := 'BOLETO'
lEnd      := .f.
__cPrgSX1 := 'BLTBAR'
aReturn   := {'Zebrado', 1,'Administracao', 2, 2, 1, '',1 }
nLastKey  := 0

Close(oDlg1)

//If SM0->M0_CODIGO <> "32"
//MSGALERT("EMPRESA NAO AUTORIZADA A EMITIR BOLETO BANCO DO BRASIL")
//Return Nil
//ENDIF

dbSelectArea('SE1')

if !Pergunte (__cPrgSX1,.t.)
   Return Nil
EndIf

LimpaFlag()

__cIdxNam := Criatrab(Nil, .f.)
__cIdxKey := "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"
__cFilter += "E1_FILIAL == '"+xFilial('SE1')+"' .and. E1_SALDO > 0 .and."
__cFilter += "E1_PREFIXO >= '"+mv_par01+"' .and. E1_PREFIXO <= '"+mv_par02+"' .and. "
__cFilter += "E1_NUM >= '"+mv_par03+"' .and. E1_NUM <= '"+mv_par04+"' .and. "
__cFilter += "E1_PARCELA >= '"+mv_par05+"' .and. E1_PARCELA <= '"+mv_par06+"' .and. "
__cFilter += "E1_CLIENTE >= '"+mv_par09+"' .and. E1_CLIENTE <= '"+mv_par10+"' .and. "
__cFilter += "E1_LOJA >= '"+mv_par11+"' .and. E1_LOJA <= '"+mv_par12+"' .and. "
__cFilter += "DTOS(E1_EMISSAO) >= '"+DtoS(mv_par13)+"' .and. DTOS(E1_EMISSAO) <= '"+DtoS(mv_par14)+"' .and. "
__cFilter += "DTOS(E1_VENCREA) >= '"+DtoS(mv_par15)+"' .and. DTOS(E1_VENCREA) <= '"+DtoS(mv_par16)+"' .and. "
__cFilter += "E1_PAGTO $ 'BO /SBO'  .and. E1_EMISNF = '2'" // EMISSAO NF SBC

IndRegua('SE1',__cIdxNam,__cIdxKey,,__cFilter,'Aguarde selecionando registros....')
dbSelectArea('SE1')
#IFNDEF TOP
	dbSetIndex(__cIdxNam + OrdBagExt())
#ENDIF
dbGoTop()

@ 001,001 TO 400,700 DIALOG oDlg TITLE 'Sele玢o de Titulos'
@ 001,001 TO 170,350 BROWSE 'SE1' MARK 'E1_OK'
@ 180,310 BMPBUTTON TYPE 01 ACTION (__lExecut := .t.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (__lExecut := .f.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED

dbGoTop()
If __lExecut
	Processa({|lEnd|MontaRel()})
Endif

RetIndex('SE1')
Ferase(__cIdxNam+OrdBagExt())

Return Nil

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北砅rograma  ? MontaRel?Autor ?Microsiga             ?Data ?13/10/03 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS			     潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?Especifico para Clientes Microsiga                         潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static Function MontaRel()

Local __oPrnBol
Local __cNroDoc :=  ' '
Local __aInfEmp := {sm0->m0_nomecom									                                 ,; //[1]Nome da Empresa
                    sm0->m0_endcob                                    							   ,; //[2]Endere鏾
						  AllTrim(sm0->m0_baircob)+', '+AllTrim(sm0->m0_cidcob)+', '+sm0->m0_estcob,; //[3]Complemento
						  'CEP: '+Subs(sm0->m0_cepcob,1,5)+'-'+Subs(sm0->m0_cepcoB,6,3)            ,; //[4]CEP
						  'PABX/FAX: '+sm0->m0_tel                                                 ,; //[5]Telefones
						  'CNPJ: ' + __cNrCNPJ																	   ,; //[6]
						  'I.E.: '+Subs(sm0->m0_insc,1,3)+'.'+Subs(sm0->m0_insc,4,3)+'.'+Subs(sm0->m0_insc,7,3)+'.'+Subs(sm0->m0_insc,10,3)}  //[7]I.E

Local __aInfTit
Local __aInfBco
Local __aInfSac
//Local __aBolTxt := {'Juros de 10,50% ao Mes / Protestar no dia '} - alterado para 4,5% ao mes e 0,15% ao dia conforme reuni鉶 do dia 18/02/2019 Ata de reuni鉶 item 5 ..... Alterado o programa por Alexandre em 19/02/2019
Local __aInfBar := {}
Local __nVlrAbt := 0
Local __cCodBco := '001'
LOCAL __aBolTxt     := { "Valor da Mora por Dia de Atraso de R$ "	,;   	   		//[1]Mora Diaria
								"Protestar no dia "}//,;   	    					//[2]Sujeito a Protesto
//                                "Conceder desconto at?o vencimento de R$ "}  		//[3]Conceder desconto


__oPrnBol:= TMSPrinter():New( 'Boleto Laser' )
__oPrnBol:Setup()
__oPrnBol:SetPortrait()
__oPrnBol:StartPage()

dbSelectArea('SE1')
dbGotop()

ProcRegua(RecCount())

While se1->(!EOF())

	IncProc()

    //Quando nao estiver selecionado despreza o registro
    If !Marked('E1_OK')
       dbSkip()
       Loop
    EndIf

	dbSelectArea('SA6')
	dbSetOrder(1)
	If !dbSeek(xFilial('SA6')+mv_par07)
		apMsgInfo('Cadastro do banco n鉶 Localizado!','Aten玢o')
		Return Nil
	EndIf

	dbSelectArea('SEE')
	dbSetOrder(1)
	If !dbSeek(xFilial('SEE')+sa6->(a6_cod+a6_agencia+a6_numcon))
		apMsgInfo('Parametro do banco n鉶 Localizado!','Aten玢o')
		Return Nil
	EndIf

	dbSelectArea('SA1')
	dbSetOrder(1)
	dbSeek(xFilial('SA1')+se1->(e1_cliente+e1_loja),.t.)

	dbSelectArea('SE1')
	__aInfBco := {Alltrim(__cCodBco) 	 			,;   // [1]Numero do Banco
				 Alltrim(sa6->a6_nome)				,;   // [2]Nome do Banco
	             Alltrim(sa6->a6_agencia)			,;   // [3]Ag阯cia
	             Alltrim(sa6->a6_dvage)			    ,;   // [4]Digito Ag阯cia
                 Alltrim(sa6->a6_numcon)			,;   // [5]Conta Corrente
                 Alltrim(sa6->a6_dvcta)			    ,;   // [6]D韌ito da conta corrente
                 Alltrim(__cCartei)					,;   // [7]Codigo da Carteira
                 Alltrim(see->ee_codemp)			}    // [8]Contrato

	If Empty(SA1->A1_ENDCOB)
		__aInfSac := {AllTrim(sa1->a1_nome)           				 							,;     	// [1]Raz鉶 Social
		              AllTrim(sa1->a1_cod)+'-'+sa1->a1_loja   	 								,;     	// [2]C骴igo
		              rTrim(sa1->a1_end)+'-'+rTrim(sa1->a1_complem)+'-'+rTrim(sa1->a1_bairro)	,;     	// [3]Endere鏾
		              rTrim(sa1->a1_mun)                          								,;  		// [4]Cidade
						  sa1->a1_est                                 							,;    	// [5]Estado
						  sa1->a1_cep                                 							,;     	// [6]CEP
						  sa1->a1_cgc										  	 				,;		// [7]CGC
						  sa1->a1_pessoa										 } 		// [8]PESSOA
	Else
		__aInfSac := {rTrim(sa1->a1_nome)            	 	  			  ,;   	// [1]Raz鉶 Social
		              rTrim(sa1->a1_cod)+'-'+sa1->a1_loja     		  ,;   	// [2]C骴igo
						  rTrim(sa1->a1_endcob)+'-'+rTrim(sa1->a1_bairroc),;   	// [3]Endere鏾
						  rTrim(sa1->a1_munc)                             ,;   	// [4]Cidade
						  sa1->a1_estc	                                   ,;   	// [5]Estado
						  sa1->a1_cepc                                    ,;   	// [6]CEP
						  sa1->a1_cgc											 	  ,;		// [7]CGC
						  sa1->a1_pessoa								 			  }		// [8]PESSOA
	EndIf

	__nVlrAbt := SomaAbat(se1->e1_prefixo,se1->e1_num,se1->e1_parcela,'R',1,,se1->e1_cliente,se1->e1_loja)

	//Aqui defino parte do nosso numero. Sao 8 digitos para identIficar o titulo.
	__cNroDoc := StrZero(Val(Alltrim(se1->e1_num)),9)+StrZero(Val(Alltrim(se1->e1_parcela)),2)
	__cNroDoc := StrZero(Val(__cNroDoc),11)

	//Monta codigo de barras
	__aInfBar := RetCodBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,__aInfBco,__cNroDoc,(se1->e1_valor-__nVlrAbt),'9')

	dbSelectArea('SE1')
	__aInfTit := {AllTrim(se1->e1_num)+AllTrim(se1->e1_parcela)		,;  // [1] N鷐ero do t韙ulo
				  	  se1->e1_emissao                               ,;  // [2] Data da emiss鉶 do t韙ulo
					  dDataBase           	         			    ,;  // [3] Data da emiss鉶 do boleto
					  se1->e1_vencto                                ,;  // [4] Data do vencimento
					  (se1->e1_saldo - __nVlrAbt)                  	,;  // [5] Valor do t韙ulo
					  __aInfBar[3]     		                        ,;  // [6] Nosso n鷐ero (Ver f髍mula para calculo)
					  se1->e1_prefixo                               ,;  // [7] Prefixo da NF
					  se1->e1_tipo	                               	,;  // [8] Tipo do Titulo
					  se1->e1_obsbol				                ,;  // [9] observacao do boleto
					  se1->e1_descont				                 }  // [10] desconto boleto

	dbSelectArea('SE1')
	If Marked('E1_OK')
		Impress(__oPrnBol,__aInfEmp,__aInfTit,__aInfBco,__aInfSac,__aBolTxt,__aInfBar)
	EndIf

	dbSkip()

EndDo

__oPrnBol:EndPage()     // Finaliza a p醙ina
__oPrnBol:Preview()     // Visualiza antes de imprimir

Return nil

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北砅rograma  ? Impress ?Autor ?Microsiga             ?Data ?13/10/03 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ?IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?EspecIfico para Clientes Microsiga                         潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static Function Impress(__oPrnBol,__aInfEmp,__aInfTit,__aInfBco,__aInfSac,__aBolTxt,__aInfBar)

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
Local oFont8   := TFont():New('Arial',9,8,.t.,.f.,5,.t.,5,.t.,.f.)
Local oFont8n  := TFont():New('Arial',9,8,.t.,.t.,5,.t.,5,.t.,.f.)
Local oFont11c := TFont():New('Courier New',9,11,.t.,.t.,5,.t.,5,.t.,.f.)
Local oFont11  := TFont():New('Arial',9,11,.t.,.t.,5,.t.,5,.t.,.f.)
Local oFont10  := TFont():New('Arial',9,10,.t.,.t.,5,.t.,5,.t.,.f.)
// Local oFont14  := TFont():New('Arial',9,14,.t.,.t.,5,.t.,5,.t.,.f.)
// Local oFont20  := TFont():New('Arial',9,20,.t.,.t.,5,.t.,5,.t.,.f.)
Local oFont21  := TFont():New('Arial',9,21,.t.,.t.,5,.t.,5,.t.,.f.)
// Local oFont16n := TFont():New('Arial',9,16,.t.,.f.,5,.t.,5,.t.,.f.)
// Local oFont15  := TFont():New('Arial',9,15,.t.,.t.,5,.t.,5,.t.,.f.)
Local oFont15n := TFont():New('Arial',9,15,.t.,.f.,5,.t.,5,.t.,.f.)
// Local oFont14n := TFont():New('Arial',9,14,.t.,.f.,5,.t.,5,.t.,.f.)
// Local oFont24  := TFont():New('Arial',9,24,.t.,.t.,5,.t.,5,.t.,.f.)

__oPrnBol:StartPage()   // Inicia uma nova p醙ina

/******************/
/* PRIMEIRA PARTE */
/******************/
nRow1 := 0

__oPrnBol:Line(0150,500,0070, 500)
__oPrnBol:Line(0150,710,0070, 710)

__oPrnBol:Say(0084,100,'Banco do Brasil',oFont11)	// [2]Nome do Banco
__oPrnBol:Say(0075,512,__aInfBco[1]+'-9',oFont21)	// [1]Numero do Banco

__oPrnBol:Say(nRow1+0084,1900,'Comprovante de Entrega',oFont10)
__oPrnBol:Line(nRow1+0150,100,nRow1+0150,2300)

__oPrnBol:Say(nRow1+0150,100 ,'Cedente',oFont8)
__oPrnBol:Say(nRow1+0200,100 ,__aInfEmp[1],oFont10)	//Nome + CNPJ

__oPrnBol:Say(nRow1+0150,1060,'Ag阯cia/C骴igo Cedente',oFont8)
__oPrnBol:Say(nRow1+0200,1060,__aInfBco[3]+'-'+__aInfBco[4]+'/'+__aInfBco[5]+'-'+__aInfBco[6],oFont10)

__oPrnBol:Say(nRow1+0150,1510,'Nro.Documento',oFont8)
__oPrnBol:Say(nRow1+0200,1510,__aInfTit[7]+__aInfTit[1],oFont10) //Prefixo+Numero+Parcela

__oPrnBol:Say(nRow1+0250,100 ,'Sacado',oFont8)
__oPrnBol:Say(nRow1+0300,100 ,__aInfSac[1],oFont10)	//Nome

__oPrnBol:Say(nRow1+0250,1060,'Vencimento',oFont8)
__oPrnBol:Say(nRow1+0300,1060,StrZero(Day(__aInfTit[4]),2) +'/'+ StrZero(Month(__aInfTit[4]),2) +'/'+ Right(Str(Year(__aInfTit[4])),4),oFont10)

__oPrnBol:Say(nRow1+0250,1510,'Valor do Documento',oFont8)
__oPrnBol:Say(nRow1+0300,1550,AllTrim(Transform(__aInfTit[5],'@E 999,999,999.99')),oFont10)

__oPrnBol:Say(nRow1+0400,0100,'Recebi(emos) o bloqueto/t韙ulo',oFont10)
__oPrnBol:Say(nRow1+0450,0100,'com as caracter韘ticas acima.',oFont10)
__oPrnBol:Say(nRow1+0350,1060,'Data',oFont8)
__oPrnBol:Say(nRow1+0350,1410,'Assinatura',oFont8)
__oPrnBol:Say(nRow1+0450,1060,'Data',oFont8)
__oPrnBol:Say(nRow1+0450,1410,'Entregador',oFont8)

__oPrnBol:Line(nRow1+0250, 100,nRow1+0250,1900)
__oPrnBol:Line(nRow1+0350, 100,nRow1+0350,1900)
__oPrnBol:Line(nRow1+0450,1050,nRow1+0450,1900)
__oPrnBol:Line(nRow1+0550, 100,nRow1+0550,2300)

__oPrnBol:Line(nRow1+0550,1050,nRow1+0150,1050)
__oPrnBol:Line(nRow1+0550,1400,nRow1+0350,1400)
__oPrnBol:Line(nRow1+0350,1500,nRow1+0150,1500)
__oPrnBol:Line(nRow1+0550,1900,nRow1+0150,1900)

__oPrnBol:Say(nRow1+0165,1910,'(  ) Mudou-se'                              ,oFont8)
__oPrnBol:Say(nRow1+0205,1910,'(  ) Ausente'                               ,oFont8)
__oPrnBol:Say(nRow1+0245,1910,'(  ) N鉶 existe n?indicado'                ,oFont8)
__oPrnBol:Say(nRow1+0285,1910,'(  ) Recusado'                              ,oFont8)
__oPrnBol:Say(nRow1+0325,1910,'(  ) N鉶 procurado'                         ,oFont8)
__oPrnBol:Say(nRow1+0365,1910,'(  ) Endere鏾 insuficiente'                	,oFont8)
__oPrnBol:Say(nRow1+0405,1910,'(  ) Desconhecido'                          ,oFont8)
__oPrnBol:Say(nRow1+0445,1910,'(  ) Falecido'                              ,oFont8)
__oPrnBol:Say(nRow1+0485,1910,'(  ) Outros(anotar no verso)'               ,oFont8)

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 	:= 0
Local nI:=1

//Pontilhado separador
For nI := 100 to 2300 step 50
	__oPrnBol:Line(0580, nI,0580, nI+30)
Next nI

__oPrnBol:Line(nRow2+0710,100,nRow2+0710,2300)
__oPrnBol:Line(nRow2+0710,500,nRow2+0630, 500)
__oPrnBol:Line(nRow2+0710,710,nRow2+0630, 710)

__oPrnBol:Say(nRow2+0644,100,'Banco do Brasil',oFont11)	//__aInfBco[2],oFont11 )		// [2]Nome do Banco
__oPrnBol:Say(nRow2+0635,512,__aInfBco[1]+'-9',oFont21)	// [1]Numero do Banco
__oPrnBol:Say(nRow2+0644,1800,'Recibo do Sacado',oFont10)

__oPrnBol:Line(nRow2+0810,100,nRow2+0810,2300)
__oPrnBol:Line(nRow2+0910,100,nRow2+0910,2300)
__oPrnBol:Line(nRow2+0980,100,nRow2+0980,2300)
__oPrnBol:Line(nRow2+1050,100,nRow2+1050,2300)

__oPrnBol:Line(nRow2+0910,500,nRow2+1050,500)
__oPrnBol:Line(nRow2+0980,750,nRow2+1050,750)
__oPrnBol:Line(nRow2+0910,1000,nRow2+1050,1000)
__oPrnBol:Line(nRow2+0910,1300,nRow2+0980,1300)
__oPrnBol:Line(nRow2+0910,1480,nRow2+1050,1480)

__oPrnBol:Say(nRow2+0710,100 ,'Local de Pagamento',oFont8)
__oPrnBol:Say(nRow2+0725,400 ,'Pag醰el em Qualquer Banco at?o Vencimento.'  ,oFont10)
__oPrnBol:Say(nRow2+0765,400 ,'Ap髎 o Vencimento, Somente no Banco do Brasil',oFont10)

__oPrnBol:Say(nRow2+0710,1810,'Vencimento'                                   ,oFont8)
__cString := StrZero(Day(__aInfTit[4]),2)+'/'+StrZero(Month(__aInfTit[4]),2)+'/'+Right(Str(Year(__aInfTit[4])),4)
__nColAju := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(nRow2+0750,__nColAju,__cString,oFont11c)

__oPrnBol:Say(nRow2+0810,100 ,'Cedente'                                      ,oFont8)
__oPrnBol:Say(nRow2+0850,100 ,__aInfEmp[1]+'     - '+__aInfEmp[6]	           ,oFont10) //Nome + __cNrCNPJ

__oPrnBol:Say(nRow2+0810,1810,'Ag阯cia/C骴igo Cedente',oFont8)
__cString := AllTrim(__aInfBco[3]+'-'+__aInfBco[4]+'/'+__aInfBco[5]+'-'+__aInfBco[6])
__nColAju := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(nRow2+0850,__nColAju,__cString,oFont11c)

__oPrnBol:Say(nRow2+0910,100 ,'Data do Documento'                            ,oFont8)
__oPrnBol:Say(nRow2+0940,100, StrZero(Day(__aInfTit[2]),2)+'/'+StrZero(Month(__aInfTit[2]),2)+'/'+Right(Str(Year(__aInfTit[2])),4),oFont10)

__oPrnBol:Say(nRow2+0910,505 ,'Nro.Documento'                                ,oFont8)
__oPrnBol:Say(nRow2+0940,605 ,__aInfTit[7]+__aInfTit[1]					        ,oFont10) //Prefixo +Numero+Parcela

__oPrnBol:Say(nRow2+0910,1005,'Esp閏ie Doc.'                                 ,oFont8)
__oPrnBol:Say(nRow2+0940,1050,'DM'										              ,oFont10) //Tipo do Titulo

__oPrnBol:Say(nRow2+0910,1305,'Aceite'                                       ,oFont8)
__oPrnBol:Say(nRow2+0940,1400,'N'                                            ,oFont10)

__oPrnBol:Say(nRow2+0910,1485,'Data do Processamento'                        ,oFont8)
__oPrnBol:Say(nRow2+0940,1550,StrZero(Day(__aInfTit[3]),2)+'/'+StrZero(Month(__aInfTit[3]),2)+'/'+Right(Str(Year(__aInfTit[3])),4),oFont10) // Data impressao

__oPrnBol:Say(nRow2+0910,1810,'Nosso N鷐ero'                                 ,oFont8)
__cString := __aInfBar[3]+'-'+__aInfBar[4]
__nColAju := 1810+(374-(len(__cString)*22))
If Len(__aInfBco[8]) < 7
	__oPrnBol:Say(nRow2+0940,__nColAju,Substr(__cString,1,13)                 ,oFont11c)
Else
	__oPrnBol:Say(nRow2+0940,__nColAju,Substr(__cString,1,14)                 ,oFont11c)
EndIf

__oPrnBol:Say(nRow2+0980,100 ,'Uso do Banco'                                 ,oFont8)

__oPrnBol:Say(nRow2+0980,505 ,'Carteira'                                     ,oFont8)
__oPrnBol:Say(nRow2+1010,555 ,__aInfBco[7]                                   ,oFont10)

__oPrnBol:Say(nRow2+0980,755 ,'Esp閏ie'                                      ,oFont8)
__oPrnBol:Say(nRow2+1010,805 ,'R$'                                           ,oFont10)

__oPrnBol:Say(nRow2+0980,1005,'Quantidade'                                   ,oFont8)
__oPrnBol:Say(nRow2+0980,1485,'Valor'                                        ,oFont8)

__oPrnBol:Say(nRow2+0980,1810,'Valor do Documento'                           ,oFont8)
__cString := AllTrim(Transform(__aInfTit[5],'@E 99,999,999.99'))
__nColAju := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(nRow2+1010,__nColAju,__cString ,oFont11c)

__oPrnBol:Say(nRow2+1050,100 ,'Instru珲es (Todas informa珲es deste bloqueto s鉶 de exclusiva responsabilidade do cedente)',oFont8)
__oPrnBol:Say(nRow2+1103,100 ,__aBolTxt[1]+" "+AllTrim(Transform(((__aInfTit[5]*(4.50/30))/100),"@E 99,999.99"))        ,oFont10)
__oPrnBol:Say(nRow2+1156,100 ,__aBolTxt[2]+StrZero(Day(__aInfTit[4]+5),2)+'/'+StrZero(Month(__aInfTit[4]+5),2)+'/'+Right(Str(Year(__aInfTit[4]+4)),4),oFont10)
if __aInfTit[10] >0
//__oPrnBol:Say(nRow2+1209,100 ,'Conceder desconto ate o vencimento no valor de R$ '+" "+AllTrim(Transform(__aInfTit[10],"@E 99,999.99")))
__oPrnBol:Say(nRow2+1209,100 ,substr(__aInfTit[9],1,85),oFont8n)
__oPrnBol:Say(nRow2+1262,100 ,substr(__aInfTit[9],86,144),oFont8n)
endif

__oPrnBol:Say(nRow2+1050,1810,'(-)Desconto/Abatimento'                       ,oFont8)
__oPrnBol:Say(nRow2+1120,1810,'(-)Outras Dedu珲es'                           ,oFont8)
__oPrnBol:Say(nRow2+1190,1810,'(+)Mora/Multa'                                ,oFont8)
__oPrnBol:Say(nRow2+1260,1810,'(+)Outros Acr閟cimos'                         ,oFont8)
__oPrnBol:Say(nRow2+1330,1810,'(=)Valor Cobrado'                             ,oFont8)

__oPrnBol:Say(nRow2+1400,100 ,'Sacado'                                       ,oFont8)
__oPrnBol:Say(nRow2+1430,400 ,__aInfSac[1]+' ('+__aInfSac[2]+')'             ,oFont10)
__oPrnBol:Say(nRow2+1483,400 ,__aInfSac[3]                                   ,oFont10)
__oPrnBol:Say(nRow2+1536,400 ,__aInfSac[4]+' - '+__aInfSac[5]+'   '+__aInfSac[6],oFont10) // CEP+Cidade+Estado

If __aInfSac[8] = 'J'
	__oPrnBol:Say(nRow2+1430,1750 ,'CNPJ: '+Transform(__aInfSac[7],'@R 99.999.999/9999-99'),oFont10) // CGC
Else
	__oPrnBol:Say(nRow2+1430,1750 ,'CPF: '+Transform(__aInfSac[7],'@R 999.999.999-99'),oFont10) 	// CPF
EndIf

__oPrnBol:Say(nRow2+1589,1850,__aInfBco[8]+' '+__aInfBar[3]+'-'+__aInfBar[4] ,oFont10)

__oPrnBol:Say(nRow2+1605,100 ,'Sacador/Avalista',oFont8)
__oPrnBol:Say(nRow2+1645,1500,'Autentica玢o Mec鈔ica',oFont8)

__oPrnBol:Line(nRow2+0710,1800,nRow2+1400,1800)
__oPrnBol:Line(nRow2+1120,1800,nRow2+1120,2300)
__oPrnBol:Line(nRow2+1190,1800,nRow2+1190,2300)
__oPrnBol:Line(nRow2+1260,1800,nRow2+1260,2300)
__oPrnBol:Line(nRow2+1330,1800,nRow2+1330,2300)
__oPrnBol:Line(nRow2+1400,100 ,nRow2+1400,2300)
__oPrnBol:Line(nRow2+1640,100 ,nRow2+1640,2300)


/******************/
/* TERCEIRA PARTE */
/******************/

/*
Posi玢o 01-03 = IdentIfica玢o do banco (exemplo: 001 = Banco do Brasil)
Posi玢o 04-04 = C骴igo de moeda (exemplo: 9 = Real)
Posi玢o 05-09 = 5 primeiras posi珲es do campo livre (posi珲es 20 a 24 do c骴igo de barras)
Posi玢o 10-10 = D韌ito verIficador do primeiro campo
Posi玢o 11-20 = 6?a 15?posi珲es do campo livre (posi珲es 25 a 34 do c骴igo de barras)
Posi玢o 21-21 = D韌ito verIficador do segundo campo
Posi玢o 22-31 = 16?a 25?posi珲es do campo livre (posi珲es 35 a 44 do c骴igo de barras)
Posi玢o 32-32 = D韌ito verIficador do terceiro campo
Posi玢o 33-33 = D韌ito verIficador geral (posi玢o 5 do c骴igo de barras)
Posi玢o 34-37 = Fator de vencimento (posi珲es 6 a 9 do c骴igo de barras)
Posi玢o 38-47 = Valor nominal do t韙ulo (posi珲es 10 a 19 do c骴igo de barras)
*/

nRow3 := 0

For nI := 100 to 2300 step 50
	__oPrnBol:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

__oPrnBol:Line(nRow3+2000,100,nRow3+2000,2300)
__oPrnBol:Line(nRow3+2000,500,nRow3+1920, 500)
__oPrnBol:Line(nRow3+2000,710,nRow3+1920, 710)

__oPrnBol:Say(nRow3+1934,100,'Banco do Brasil',oFont11)	//__aInfBco[2],oFont11 )		// 	[2]Nome do Banco
__oPrnBol:Say(nRow3+1925,512,__aInfBco[1]+'-9',oFont21)	// 	[1]Numero do Banco
__oPrnBol:Say(nRow3+1934,755,__aInfBar[2],oFont15n)		//		Linha Digitavel do Codigo de Barras

__oPrnBol:Line(nRow3+2100,100,nRow3+2100,2300)
__oPrnBol:Line(nRow3+2200,100,nRow3+2200,2300)
__oPrnBol:Line(nRow3+2270,100,nRow3+2270,2300)
__oPrnBol:Line(nRow3+2340,100,nRow3+2340,2300)

__oPrnBol:Line(nRow3+2200,500 ,nRow3+2340,500)
__oPrnBol:Line(nRow3+2270,750 ,nRow3+2340,750)
__oPrnBol:Line(nRow3+2200,1000,nRow3+2340,1000)
__oPrnBol:Line(nRow3+2200,1300,nRow3+2270,1300)
__oPrnBol:Line(nRow3+2200,1480,nRow3+2340,1480)

__oPrnBol:Say(nRow3+2000,100 ,'Local de Pagamento',oFont8)
__oPrnBol:Say(nRow3+2015,400 ,'Pag醰el em Qualquer Banco at?o Vencimento.'	,oFont10)
__oPrnBol:Say(nRow3+2055,400 ,'Ap髎 o Vencimento, Somente no Banco do Brasil' ,oFont10)

__oPrnBol:Say(nRow3+2000,1810,'Vencimento',oFont8)
__cString := StrZero(Day(__aInfTit[4]),2)+'/'+StrZero(Month(__aInfTit[4]),2)+'/'+Right(Str(Year(__aInfTit[4])),4)
__nColAju := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(nRow3+2040,__nColAju,__cString,oFont11c)

__oPrnBol:Say(nRow3+2100,100 ,'Cedente',oFont8)
__oPrnBol:Say(nRow3+2140,100 ,__aInfEmp[1]+'     - '+__aInfEmp[6]					,oFont10) //Nome + __cNrCNPJ

__oPrnBol:Say(nRow3+2100,1810,'Ag阯cia/C骴igo Cedente',oFont8)
__cString := AllTrim(__aInfBco[3]+'-'+__aInfBco[4]+'/'+__aInfBco[5]+'-'+__aInfBco[6])
__nColAju := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(nRow3+2140,__nColAju,__cString 											,oFont11c)

__oPrnBol:Say(nRow3+2200,100 ,'Data do Documento'                             ,oFont8)
__oPrnBol:Say(nRow3+2230,100, StrZero(Day(__aInfTit[2]),2)+'/'+StrZero(Month(__aInfTit[2]),2)+'/'+Right(Str(Year(__aInfTit[2])),4), oFont10)

__oPrnBol:Say(nRow3+2200,505 ,'Nro.Documento'                                 ,oFont8)
__oPrnBol:Say(nRow3+2230,605 ,__aInfTit[7]+__aInfTit[1]								,oFont10) //Prefixo +Numero+Parcela

__oPrnBol:Say(nRow3+2200,1005,'Esp閏ie Doc.'                                  ,oFont8)
__oPrnBol:Say(nRow3+2230,1050,'DM'															,oFont10) //Tipo do Titulo

__oPrnBol:Say(nRow3+2200,1305,'Aceite'                                        ,oFont8)
__oPrnBol:Say(nRow3+2230,1400,'N'                                             ,oFont10)

__oPrnBol:Say(nRow3+2200,1485,'Data do Processamento'                         ,oFont8)
__oPrnBol:Say(nRow3+2230,1550,StrZero(Day(__aInfTit[3]),2)+'/'+StrZero(Month(__aInfTit[3]),2)+'/'+Right(Str(Year(__aInfTit[3])),4)                               ,oFont10) // Data impressao

__oPrnBol:Say(nRow3+2200,1810,'Nosso N鷐ero'                                  ,oFont8)
__cString := __aInfBar[3]+'-'+__aInfBar[4]
__nColAju := 1810+(374-(len(__cString)*22))
If Len(__aInfBco[8]) < 7
	__oPrnBol:Say(nRow3+2230,__nColAju,Substr(__cString,1,13)						,oFont11c)
Else
	__oPrnBol:Say(nRow3+2230,__nColAju,Substr(__cString,1,14)						,oFont11c)
EndIf

__oPrnBol:Say(nRow3+2270,100 ,'Uso do Banco'                  						,oFont8)

__oPrnBol:Say(nRow3+2270,505 ,'Carteira'                      						,oFont8)
__oPrnBol:Say(nRow3+2300,555 ,__aInfBco[7]                  						,oFont10)

__oPrnBol:Say(nRow3+2270,755 ,'Esp閏ie'                       						,oFont8)
__oPrnBol:Say(nRow3+2300,805 ,'R$'                            						,oFont10)

__oPrnBol:Say(nRow3+2270,1005,'Quantidade'                    						,oFont8)
__oPrnBol:Say(nRow3+2270,1485,'Valor'                         						,oFont8)

__oPrnBol:Say(nRow3+2270,1810,'Valor do Documento'            						,oFont8)
__cString := AllTrim(Transform(__aInfTit[5],'@E 99,999,999.99'))
__nColAju := 1810+(374-(len(__cString)*22))
__oPrnBol:Say(nRow3+2300,__nColAju,__cString												,oFont11c)

__oPrnBol:Say(nRow3+2340,100 ,'Instru珲es (Todas informa珲es deste bloqueto s鉶 de exclusiva responsabilidade do cedente)',oFont8)
__oPrnBol:Say(nRow3+2393,100 ,__aBolTxt[1]+" "+AllTrim(Transform(((__aInfTit[5]*(4.50/30))/100),"@E 99,999.99"))        ,oFont10)
__oPrnBol:Say(nRow3+2446,100 ,__aBolTxt[2]+StrZero(Day(__aInfTit[4]+5),2)+'/'+StrZero(Month(__aInfTit[4]+5),2)+'/'+Right(Str(Year(__aInfTit[4]+4)),4) ,oFont10)
if __aInfTit[10] >0
//__oPrnBol:Say(nRow3+2499,100 ,'Conceder desconto ate o vencimento no valor de R$ '+" "+AllTrim(Transform(__aInfTit[10],"@E 99,999.99")))
	__oPrnBol:Say(nRow3+2499,100 ,substr(__aInfTit[9],1,85),oFont8n)
	__oPrnBol:Say(nRow3+2552,100 ,substr(__aInfTit[9],86,144),oFont8n)
endif


__oPrnBol:Say(nRow3+2340,1810,'(-)Desconto/Abatimento'                        ,oFont8)
__oPrnBol:Say(nRow3+2410,1810,'(-)Outras Dedu珲es'                            ,oFont8)
__oPrnBol:Say(nRow3+2480,1810,'(+)Mora/Multa'                                 ,oFont8)
__oPrnBol:Say(nRow3+2550,1810,'(+)Outros Acr閟cimos'                          ,oFont8)
__oPrnBol:Say(nRow3+2620,1810,'(=)Valor Cobrado'                              ,oFont8)

__oPrnBol:Say(nRow3+2690,100 ,'Sacado'                                        ,oFont8)
__oPrnBol:Say(nRow3+2700,400 ,__aInfSac[1]+' ('+__aInfSac[2]+')'             	,oFont10)

If __aInfSac[8] = 'J'
	__oPrnBol:Say(nRow3+2700,1750,'CNPJ: '+Transform(__aInfSac[7],'@R 99.999.999/9999-99'),oFont10) // CGC
Else
	__oPrnBol:Say(nRow3+2700,1750,'CPF: '+Transform(__aInfSac[7],'@R 999.999.999-99'),oFont10) 	// CPF
EndIf

__oPrnBol:Say(nRow3+2753,400 ,__aInfSac[3]                                  	,oFont10)
__oPrnBol:Say(nRow3+2806,400 ,__aInfSac[4]+' - '+__aInfSac[5]+'   '+__aInfSac[6],oFont10) // CEP+Cidade+Estado correto cidade+uf+cep
__oPrnBol:Say(nRow3+2806,1750,__aInfBco[8]+' '+__aInfBar[3]+'-'+__aInfBar[4]  ,oFont10)

__oPrnBol:Say(nRow3+2851,100 ,'Sacador/Avalista'                              ,oFont8)
__oPrnBol:Say(nRow3+2891,1500,'Autentica玢o Mec鈔ica - Ficha de Compensa玢o'  ,oFont8)

__oPrnBol:Line(nRow3+2000,1800,nRow3+2690,1800)
__oPrnBol:Line(nRow3+2410,1800,nRow3+2410,2300)
__oPrnBol:Line(nRow3+2480,1800,nRow3+2480,2300)
__oPrnBol:Line(nRow3+2550,1800,nRow3+2550,2300)
__oPrnBol:Line(nRow3+2620,1800,nRow3+2620,2300)
__oPrnBol:Line(nRow3+2690,100 ,nRow3+2690,2300)

__oPrnBol:Line(nRow3+2881,100,nRow3+2881,2300)

MSBAR('INT25',25,1,__aInfBar[1],__oPrnBol,.f.,Nil,Nil,0.025,1.5,Nil,Nil,'A',.f.)

For nI := 100 to 2300 step 50
	__oPrnBol:Line(nRow3+3150, nI, nRow3+3150, nI+30)
Next nI

dbSelectArea('SE1')
RecLock('SE1',.f.)
se1->e1_numbco := Iif(Len(AllTrim(__aInfBco[8])) == 7,Substr(__aInfBar[3],1,10),Substr(__aInfBar[3],7,5))+__aInfBar[4] //__aInfBar[3]+__cDigTit  //nosso n鷐ero (ver f髍mula para calculo)
SE1->E1_NOMEUSE  := CUSERNAME                       // NOME DO USUARIO QUE GEROU O BOLETO
SE1->E1_BKPNNUM  := SE1->E1_NUMBCO  	            // BACKUP DO NOSSO NUMERO
SE1->E1_BKPPORT := SE1->E1_PORTADO               // BANCO SELECIONADO NOS PARAMETROS
SE1->E1_BKPAGEN  := SE1->E1_AGEDEP               // AGENCIA SELECIONADA NOS PARAMETROS
SE1->E1_BKPCONT  := SE1->E1_CONTA               // CONTA SELECIONADA NOS PARAMETROS
SE1->E1_DATABO   := dDataBase                 // DATA DA GERACAO DO BOLETO
SE1->E1_HORABO   := TIME()                          // HORA DA GERACAO DO BOLETO
MsUnlock()

__oPrnBol:EndPage() // Finaliza a p醙ina

Return Nil

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    砇etDados  篈utor  矼icrosiga           ?Data ? 02/13/04   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矴era SE1                        					          	  罕?
北?         ?                                                           罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?BOLETOS                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static Function RetCodBar(__cPrfTit,__cNroTit,__cParTit,__cTipTit,__aInfBco,__cNroDoc,__nVlrTit,__cMoedas)

Local __cNosNro := ''
Local __cCpoLiv := ''
Local __fVctVlr := ''
Local __cLivres := ''
Local __cDigBar := ''
Local __cCodBar := ''
Local __cParte1 := ''
Local __cDigit1 := ''
Local __cParte2 := ''
Local __cDigit2 := ''
Local __cParte3 := ''
Local __cDigit3 := ''
Local __cParte4 := ''
Local __cParte5 := ''
Local __cLinDig := ''
// Local __cParTit := ''
Local __cNumSE1 := ''
Local __aReturn := {}

Private __nNumero := ''

Public __cDigTit := ''

//Nosso Numero
If se1->e1_portado == sa6->a6_cod .or. se1->e1_agedep == sa6->a6_agencia
	__cNumSE1 := Iif(Len(AllTrim(__aInfBco[8])) == 7,Iif(Len(AllTrim(se1->e1_numbco))==11,Substr(se1->e1_numbco,1,11),''),Iif(Len(AllTrim(se1->e1_numbco))==6,Substr(se1->e1_numbco,1,6),''))
Else
	__cNumSE1 := ''
EndIf

If !Empty(__cNumSE1)
   __nNumber := Iif(Len(AllTrim(__aInfBco[8])) == 7,Substr(__cNumSE1,1,11),Substr(__cNumSE1,1,6))
   __cNosNro := Iif(Len(AllTrim(__aInfBco[8])) == 7,Substr(__cNumSE1,1,10),AllTrim(__aInfBco[8])+Substr(__cNumSE1,1,5))
   __cDigTit := Iif(Len(AllTrim(__aInfBco[8])) == 7,Substr(__cNumSE1,11,1),Substr(__cNumSE1,6,1))
Else
   __cNosNro := Iif(Len(AllTrim(__aInfBco[8])) == 7,GetMV('MV_SQNUMSB'),GetMV('MV_SQNUMBB'))
   __cNosNro := Iif(Len(AllTrim(__aInfBco[8])) == 7,StrZero(Val(__cNosNro)+1,10),AllTrim(__aInfBco[8])+StrZero(Val(__cNosNro)+1,5))
   __cDigTit := CalcDigito(__cNosNro)
   __nNumero := __cNosNro+__cDigTit
EndIf

dbSelectArea('SE1')
RecLock('SE1',.f.)
se1->e1_numbco  := Iif(Len(AllTrim(__aInfBco[8])) == 7,Iif(!Empty(__cNumSE1), Substr(__nNumber,1,11), Substr(__nNumero,1,11)),Substr(__nNumero,7,5)) //__nNumero
se1->e1_portado := sa6->a6_cod
se1->e1_agedep  := sa6->a6_agencia
se1->e1_conta   := sa6->a6_numcon
msUnlock()

//gravo o numero sequencia do banco do brasil no arquivo de parametros
dbSelectArea('SX6')
dbSetOrder(1)
If Len(AllTrim(__aInfBco[8])) == 7
	dbSeek('  '+'MV_SQNUMSB')// nosso numero para a parte com nota fiscal quando o imposto st sai separado
Else
   dbSeek('  '+'MV_SQNUMBB')// nosso numero para a parte com nota fiscal normal
EndIf
	If !Empty(__nNumero)
	IF (Len(AllTrim(__aInfBco[8]))) == 7
		PUTMV("MV_SQNUMSB",Substr(__nNumero,1,10))  //REMOVIDO EM 06/06/2023 AP覵 VIRADA A VERSAO 2210 ERRO DE COMPILA敲O LUCAS QUE FEZ
	ELSE
		PUTMV("MV_SQNUMBB",Substr(__nNumero,7,5))
	ENDIF
	ENDIF

  	// Reclock('SX6',.f.)
//  	sx6->x6_conteud := Iif(Len(AllTrim(__aInfBco[8])) == 7,Substr(__nNumero,1,10),Substr(__nNumero,7,5))
//   MsUnlock()

//EndIf

If __nVlrTit > 0
	__fVctVlr := CalcFator()+StrZero(__nVlrTit*100,10)
Else
	__fVctVlr := CalcFator()+StrZero(se1->e1_valor*100,10)
EndIf

If Len(AllTrim(__aInfBco[8])) == 7
	__cCpoLiv := '000000'+AllTrim(__aInfBco[8])+AllTrim(__cNosNro)+Substr(AllTrim(__aInfBco[7]),1,2)
Else
	//__cCpoLiv := AllTrim(__aInfBco[8])+AllTrim(__cNosNro)+AllTrim(__aInfBco[3])+SubStr('00000'+AllTrim(__aInfBco[5]),1,8)+Substr(AllTrim(__aInfBco[7]),1,2)
	__cCpoLiv := AllTrim(__cNosNro)+AllTrim(__aInfBco[3])+SubStr('00000'+AllTrim(__aInfBco[5]),1,8)+Substr(AllTrim(__aInfBco[7]),1,2)
EndIf

__cLivres := __aInfBco[1]+__cMoedas+__fVctVlr+__cCpoLiv

// campo do codigo de barra
__cDigBar := CalcDigBarra(__cLivres)

__cCodBar := Substr(__cLivres,1,4)+__cDigBar+Substr(__cLivres,5,39)

// composicao da linha digitavel
__cParte1 := __aInfBco[1]+__cMoedas+Substr(__cCodBar,20,5)
__cDigit1 := CalcModulo10( __cParte1,1 )
__cParte2 := Substr(__cCodBar,25,10 )
__cDigit2 := CalcModulo10( __cParte2,2 )
__cParte3 := Substr(__cCodBar,35,10)
__cDigit3 := CalcModulo10( __cParte3,2 )
__cParte4 := __cDigBar
__cParte5 := __fVctVlr

__cLinDig := Substr(__cParte1,1,5)+'.'+Substr(__cParte1,6,4)+__cDigit1+' '+Substr(__cParte2,1,5)+'.'+Substr(__cParte2,6,5)+__cDigit2+' '+;
	Substr(__cParte3,1,5)+'.'+Substr(__cParte3,6,5)+__cDigit3+' '+__cParte4+' '+__cParte5

aAdd(__aReturn,__cCodBar)
aAdd(__aReturn,__cLinDig)
aAdd(__aReturn,__cNosNro)
aAdd(__aReturn,__cDigTit)

Return __aReturn

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矯alcDigito篈utor  矼icrosiga           ?Data ? 02/13/04   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     砅ara calculo do nosso numero do banco do brasil             罕?
北?         ?                                                           罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?BOLETOS                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static Function CalcDigito(__nNumero)

Local __nSomDig := 0
Private __nAuxili := 0

__nNroBas := __nNumero
__nQtdCar := Len(__nNroBas)
__nFtrBas := 9
__nSomDig := 0
__nAuxili := 0
__nLidCar := __nQtdCar

While __nLidCar >= 1
	If __nFtrBas == 1
		__nFtrBas := 9
	EndIf

	__nAuxili := Val(Substr(__nNroBas, __nLidCar, 1)) * __nFtrBas
	__nSomDig := __nSomDig+__nAuxili
	__nFtrBas := __nFtrBas - 1
	__nLidCar := __nLidCar-1
End

__nAuxili := Mod(__nSomDig,11)

If __nAuxili == 10
	__nAuxili := 'X'
Else
	__nAuxili := Str(__nAuxili,1,0)
EndIf

Return(__nAuxili)

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矯alcModulo10篈utor  矼icrosiga         ?Data ? 02/13/04   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     砅ara calculo da linha digitavel do Banco do Brasil          罕?
北?         ?                                                           罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?BOLETOS                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static Function CalcModulo10(__cVarRec,__nOperac)

Local __aResMlt := {}  // Resultado das Multiplicacoes de cada algarismo
Local __aMatBas := {}
Local __nSomato := 0
Local __cDigVer := 0
Local __nNroBas := __cVarRec
Local nB := 0
Local nC := 0

If __nOperac == 1
  __aMatBas := {2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
Else
  __aMatBas := {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1}
EndIf

For nB := 1 To Len(__nNroBas)
		__nResMlt := Val(Subs(__nNroBas,nB,1) ) * __aMatBas[nB]
		aAdd(__aResMlt,StrZero(__nResMlt,2) )
next nB

For nC := 1 To Len(__aResMlt)
		__nAlgar1 := Val(Subs(__aResMlt[nC],1,1))
		__nAlgar2 := Val(Subs(__aResMlt[nC],2,1))
		__nSomato += __nAlgar1 + __nAlgar2
Next nC

__cDigVer := 10 - Mod(__nSomato,10)

If __cDigVer == 10
   __cDigVer := 0
EndIf

Return(str(__cDigVer,1,0))

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矲ATOR		篈utor  矼icrosiga           ?Data ? 02/13/04   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矯alculo do CalcFator  de vencimento para linha digitavel.   罕?
北?         ?                                                           罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?BOLETOS                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static function CalcFator()

//If Len(AllTrim(Substr(DtoC(se1->e1_vencto),7,4))) = 4
//	__cCalDat := Substr(DtoC(se1->e1_vencto),7,4)+Substr(DtoC(se1->e1_vencto),4,2)+Substr(DtoC(se1->e1_vencto),1,2)
//Else
//	__cCalDat := '20'+Substr(DtoC(se1->e1_vencto),7,2)+Substr(DtoC(se1->e1_vencto),4,2)+Substr(DtoC(se1->e1_vencto),1,2)
//EndIf
//__cFatDat := STR(1000+(StoD(__cCalDat)-StoD('20000703')),4)

Local __cFatDat := StrZero(se1->e1_vencto - Iif(se1->e1_vencto >= Ctod('22/02/25'), CtoD('29/05/22'), CtoD("07/10/97")), 4)

Return(__cFatDat)

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篎uncao    矯alcDigBarra篈utor  矼icrosiga         ?Data ? 02/13/04   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矯alculo do DV cod. Barras                                   罕?
北?         ?                                                           罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?BOLETOS                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?*/
Static Function CalcDigBarra(__cVarRec)

// Local __nAuxili := 0
// local __nSomDig := 0
                  //1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3
Local __aFtrBas := {4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2}
Local __nMultip := 0
Local __aMultip := {}
Local __nDigBar := 0
Local __nVrSoma := 0
Local __nNroBas  := __cVarRec
Local nD := 0
Local nE := 0

For nD := 1 To Len(__nNroBas)
		__nMultip := Val(Subs(__nNroBas,nD,1) ) * __aFtrBas[nD]
		aAdd(__aMultip,StrZero(__nMultip,2) )
next nD

__nVrSoma := 0
__nAlgar1 := 0

For nE := 1 To Len(__aMultip)
    	__nAlgar1 := Val(__aMultip[nE])
		__nVrSoma := __nVrSoma + __nAlgar1
Next nC

__nDigBar := 11 - Mod(__nVrSoma,11)

If __nDigBar == 0  .or. __nDigBar == 1 .or. __nDigBar == 10 .or. __nDigBar == 11
   __nDigBar := 1
EndIf

Return(Str(__nDigBar,1,0))

////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LimpaFlag()

dbSelectArea('SE1')
dbSetOrder(1)
dbSeek(xFilial('SE1')+mv_par01+mv_par03,.t. )

ProcRegua(RecCount())

While se1->(!EOF()) .and. se1->e1_num <= mv_par04
   IncProc('Limpando flag...' )
   Reclock('SE1',.f.)
   se1->e1_ok := Space(2)
   MsUnlock()
   dbSkip()
End

Return Nil
