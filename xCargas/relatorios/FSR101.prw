#include "totvs.ch"
#INCLUDE "COLORS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������?��
���Programa  �FSR101 �    Autor � J�lio C�sar           � Data �  30/01/18���
�������������������������������������������������������������������������?��
���Descricao � RELAT�RIO DE NOTAS FICASIS DE MESMO CLIENTE                ���
���          �                                                            ���
�������������������������������������������������������������������������?��
���Uso       �                                                            ���
�������������������������������������������������������������������������?��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                                                                    	
/*/

user function FSR101()

	local cTabCap	:= 	GetNextAlias()
	
	private oPrn	
	private lastClient  := ""
	private aNotas		:= {}
	private cCarga 		:= ZA4->ZA4_CODCAR
	private cFil		:= ZA4->ZA4_FILIAL
	
	private oFont1	:=	TFont():New( "Tahoma",,18,,.T.,,,,.T.,.F. )
	private oFont2	:=	TFont():New( "Tahoma",,18,,.F.,,,,.T.,.F. )
	private oFont3	:=	TFont():New( "Tahoma",,18,,.F.,,,,.T.,.F., .T. )
	private oFont4	:=	TFont():New( "Tahoma",,16,,.F.,,,,.T.,.F., .T. )
	private oFont5	:=	TFont():New( "Arial",,20,,.T.,,,,.T.,.F. )
	private oFont6	:=	TFont():New( "Tahoma",,13,,.T.,,,,.T.,.F. )
	private oFont7	:=	TFont():New( "Tahoma",,13,,.F.,,,,.T.,.F.)
	
	private oBrush	:=	TBrush():New( , CLR_LIGHTGRAY )
	
	if ZA4->ZA4_STATUS != 'F' .And. ZA4->ZA4_STATUS != 'P' .And. ZA4->ZA4_STATUS != 'T'
		alert("Imposs�vel imprimir devido ao status da carga.")
		return()
	endif
	
	oPrn := TMSPrinter():New()
	oPrn:setPortrait()
	oPrn:SetPaperSize(9) // A4
	oPrn:Setup()
	
	
	BEGINSQL ALIAS cTabCap
		SELECT 	C5_CLIENTE,
				C5_NUM, 
				C5_XCARGA, 
				C5_XTPVEND, 
				C5_NOTA, 
				C5_SERIE, 
				C5_VOLUME1 ,
				C5_FILIAL
		FROM %table:SC5% 
		WHERE 	C5_TIPO = 'N' AND
				C5_XCARGA = %exp:cCarga% AND
				C5_FILIAL = %exp:cFil%
		ORDER BY C5_CLIENTE
			
	ENDSQL

	aArea 	:= GetArea()
	
	lastClient := (cTabCap)->C5_CLIENTE
	
	WHILE (cTabCap)->(!EOF())
		if (cTabCap)->C5_CLIENTE != lastClient
			if temBonificacao(aNotas)
				imprimir(aNotas)
			endif
			lastClient := (cTabCap)->C5_CLIENTE
			aNotas := {}
		endif

		aAdd(aNotas, {;
						(cTabCap)->C5_CLIENTE,;
						(cTabCap)->C5_NUM,; 
						(cTabCap)->C5_XCARGA,; 
						(cTabCap)->C5_XTPVEND,; 
						(cTabCap)->C5_NOTA,; 
						(cTabCap)->C5_SERIE,; 
						cvaltochar((cTabCap)->C5_VOLUME1)})
		(cTabCap)->(DBSKIP())
	ENDDO
	if !empty(aNotas) .And. temBonificacao(aNotas)
		imprimir(aNotas)
		aNotas := {}
	endif
	(cTabCap)->(DBCLOSEAREA())
	
	oPrn:Preview()
	MS_FLUSH()
	restArea(aArea)
return()

static function Imprimir(aDados)
	local nLin := 300
	local nRow := 150
	local nX
	
	oPrn:StartPage() 
	
	//oPrn:Box(055, 055, 3450, 2420)
	//oPrn:Box(060, 060, 400, 524)
	oPrn:SayBitmap(100, 100, "logots.bmp",512, 375)
	
	//Cabe�alho
	oPrn:Say(nLin-180, nRow+530, "ALIMENTOS TIA S�NIA", oFont1)
	oPrn:Say(nLin-85, nRow+530, "VIT�RIA DA CONQUISTA - BA, "+dtoc(Date())+"  ", oFont4)
	nLin += 250
	//Dados cliente
	oPrn:Say(nLin, nRow, "Granola Tia S�nia", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "Alimentos Tia S�nia Ltda", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "Rua Professora Francisca Santos, 26, Bela Vista", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "CEP.45.023-490", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "Vitoria da Conquista - Bahia", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "CNPJ 08.385.685/0002-24", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "IE 072612834", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "E-mail: faturamento@tiasonia.com.br", oFont2)
	nLin += 85
	oPrn:Say(nLin, nRow, "Telefax: (77)3424-8000", oFont2)
	nLin += 350
	
	//BOX
	oPrn:Box(nLin, nRow, nLin+330, 2360)
	oPrn:Say(nLin+30, nRow + (2360-nRow)/2, "ESSA MERCADORIA SE REFERE A NOTAS FISCAIS", oFont5,,,,2)
	nLin+=100
	oPrn:Say(nLin+30, nRow + (2360-nRow)/2, "DO MESMO CLIENTE", oFont5,,,,2)
	nLin+=100
	oPrn:Say(nLin+30, nRow + (2360-nRow)/2, "  Conjulgar no mesmo conhecimento  ", oFont3,,,,2)
	
	//Detalhes das notas
	nLin+= 250
	
	pTextBox(oPrn, nLin, nRow, nLin+80, nRow+1350, "Notas", 0, oFont1, .T., oBrush)
	nLin += 80
	
	pTextBox(oPrn, nLin, nRow, nLin+60, nRow+400, "N. Fiscal", 0, oFont6)
	pTextBox(oPrn, nLin, nRow+400, nLin+60, nRow+650, "S�rie", 0, oFont6)
	pTextBox(oPrn, nLin, nRow+650, nLin+60, nRow+1000, "Qtd. de Vol.", 0, oFont6)
	pTextBox(oPrn, nLin, nRow+1000, nLin+60, nRow+1350, "Tipo", 0, oFont6)
	nLin += 60
	
	for nX := 1 to len(aDados)
		pTextBox(oPrn, nLin, nRow, nLin+60, nRow+400, aDados[nX, 5], 0, oFont7)
		pTextBox(oPrn, nLin, nRow+400, nLin+60, nRow+650, aDados[nX, 6], 0, oFont7)
		pTextBox(oPrn, nLin, nRow+650, nLin+60, nRow+1000, aDados[nX, 7], 0, oFont7)
		pTextBox(oPrn, nLin, nRow+1000, nLin+60, nRow+1350, tipoNota(aDados[nX, 4]), 0, oFont7)
		nLin += 60
	next nX
	//Finalizando
	nLin := 3000
	nRow := 1240
	oPrn:Say(nlin, nRow, "Atenciosamente,", oFont2)
	nlin += 180
	oPrn:Line(nLin, nRow, nLin, nRow+800)
	nLin += 25
	oPrn:Say(nlin, nRow, "Alimentos Tia S�nia", oFont2)

	oPrn:EndPage()
	
return()

static function tipoNota(cTipo)
	do case
		case cTipo == 'N'
			return 'NORMAL'
		otherwise
			return 'BONIFICA��O'
	endcase
return ''

static function temBonificacao(aDados)
	local nX
	
	for nX := 1 to len(aDados)
		if aDados[nX, 4] != 'N'
			return .T.
		endif
	next nX
return .F.

static function pTextBox(oPrn, nPosY, nPosX, nAltura, nLargura, cText, nAlign, oFont, lFill, oBrush, lNoBox)
	local posX															//Vari�vel que definir� onde come�ar� o texto, de acordo com o alinhamento
	local nMarginX, nMarginY											//Margens do texto
	nMarginX := 10
	nMarginY := 10
	if lFill == .T.														//Verifica se � para preencher o bloco ou n�o
		oPrn:FillRect({nPosY, nPosX, nAltura, nLargura}, oBrush)					//Cria uma caixa preenchida
	endif
	if lNoBox != .T.
		oPrn:Box(nPosY	, nPosX, nAltura, nLargura)						//Cria a caixa do texto
	endif
	do case																//Verifica qual o tipo de alinhamento desejado
		case nAlign = 0
			posX = nPosX+nMarginX										//Posi��o inicial, alinhamento � esquerda
		case nAlign = 1
			posX = nLargura-nMarginX									//Posi��o inicial, alinhamento � direita
		case nAlign = 2
			posX = nLargura+((nLargura-nPosX)/2)						//Posi��o inicial, alinhamento central
		otherwise
			posX = nPosX+nMarginX										//Padr�o, alinhamento � esquerda
			nAlign = 0
	endcase
	oPrn:Say(nPosY,posX,cText,oFont,nLargura-nPosX,,,nAlign)	//Cria o texto
return 1
