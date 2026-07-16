object DM: TDM
  OnCreate = DataModuleCreate
  Height = 380
  Width = 547
  PixelsPerInch = 96
  object Conexao: TIBDatabase
    Connected = False
    DatabaseName = 
      '127.0.0.1/3050:C:\Avaliacao Delphi_Firebird\Andre_luis\Dados\DBA' +
      'VALIACAO.IB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=1652498327'
      'lc_ctype=WIN1252')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    ServerType = 'IBServer'
    AllowStreamedConnected = False
    Left = 32
    Top = 16
  end
  object SqlCliente: TIBQuery
    Database = Conexao
    Transaction = IBTransaction1
    ForcedRefresh = True
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    SQL.Strings = (
      'select * from Cliente order by Codigo')
    UpdateObject = IBUpdateSQLCliente
    PrecommittedReads = False
    Left = 32
    Top = 88
    object SqlClienteCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CLIENTE.CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SqlClienteNOME: TIBStringField
      FieldName = 'NOME'
      Origin = 'CLIENTE.NOME'
      Required = True
      Size = 60
    end
    object SqlClienteTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = 'CLIENTE.TIPO'
      Size = 1
    end
    object SqlClienteCPF: TIBStringField
      FieldName = 'CPF'
      Origin = 'CLIENTE.CPF'
      Size = 11
    end
    object SqlClienteCNPJ: TIBStringField
      FieldName = 'CNPJ'
      Origin = 'CLIENTE.CNPJ'
      Size = 14
    end
    object SqlClienteCEP: TIBStringField
      FieldName = 'CEP'
      Origin = 'CLIENTE.CEP'
      Size = 8
    end
    object SqlClienteENDERECO: TIBStringField
      FieldName = 'ENDERECO'
      Origin = 'CLIENTE.ENDERECO'
      Size = 60
    end
    object SqlClienteNUMERO: TIBStringField
      FieldName = 'NUMERO'
      Origin = 'CLIENTE.NUMERO'
      Size = 10
    end
    object SqlClienteBAIRRO: TIBStringField
      FieldName = 'BAIRRO'
      Origin = 'CLIENTE.BAIRRO'
      Size = 30
    end
    object SqlClienteCIDADE: TIBStringField
      FieldName = 'CIDADE'
      Origin = 'CLIENTE.CIDADE'
      Size = 30
    end
    object SqlClienteTELEFONE: TIBStringField
      FieldName = 'TELEFONE'
      Origin = 'CLIENTE.TELEFONE'
      Size = 16
    end
    object SqlClienteOBSERVACAO: TWideMemoField
      FieldName = 'OBSERVACAO'
      Origin = 'CLIENTE.OBSERVACAO'
      ProviderFlags = [pfInUpdate]
      BlobType = ftWideMemo
      Size = 8
    end
    object SqlClienteRENDA_MENSAL: TIBBCDField
      FieldName = 'RENDA_MENSAL'
      Origin = 'CLIENTE.RENDA_MENSAL'
      DisplayFormat = '0.00'
      Precision = 18
      Size = 2
    end
    object SqlClienteLIMITE_CREDITO: TIBBCDField
      FieldName = 'LIMITE_CREDITO'
      Origin = 'CLIENTE.LIMITE_CREDITO'
      DisplayFormat = '0.00'
      currency = True
      Precision = 18
      Size = 2
    end
    object SqlClienteTOTAL_COMPRAS: TIBBCDField
      FieldName = 'TOTAL_COMPRAS'
      Origin = 'CLIENTE.TOTAL_COMPRAS'
      DisplayFormat = '0.00'
      currency = True
      Precision = 18
      Size = 2
    end
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = Conexao
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 128
    Top = 16
  end
  object CDSCliente: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    ProviderName = 'DSPCliente'
    Left = 32
    Top = 160
    object CDSClienteCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CLIENTE.CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object CDSClienteNOME: TWideStringField
      FieldName = 'NOME'
      Origin = 'CLIENTE.NOME'
      Required = True
      Size = 60
    end
    object CDSClienteTIPO: TWideStringField
      FieldName = 'TIPO'
      Origin = 'CLIENTE.TIPO'
      Size = 1
    end
    object CDSClienteCPF: TWideStringField
      FieldName = 'CPF'
      Origin = 'CLIENTE.CPF'
      Size = 11
    end
    object CDSClienteCNPJ: TWideStringField
      FieldName = 'CNPJ'
      Origin = 'CLIENTE.CNPJ'
      Size = 14
    end
    object CDSClienteCEP: TWideStringField
      FieldName = 'CEP'
      Origin = 'CLIENTE.CEP'
      Size = 8
    end
    object CDSClienteENDERECO: TWideStringField
      FieldName = 'ENDERECO'
      Origin = 'CLIENTE.ENDERECO'
      Size = 60
    end
    object CDSClienteNUMERO: TWideStringField
      FieldName = 'NUMERO'
      Origin = 'CLIENTE.NUMERO'
      Size = 10
    end
    object CDSClienteBAIRRO: TWideStringField
      FieldName = 'BAIRRO'
      Origin = 'CLIENTE.BAIRRO'
      Size = 30
    end
    object CDSClienteCIDADE: TWideStringField
      FieldName = 'CIDADE'
      Origin = 'CLIENTE.CIDADE'
      Size = 30
    end
    object CDSClienteTELEFONE: TWideStringField
      FieldName = 'TELEFONE'
      Origin = 'CLIENTE.TELEFONE'
      Size = 16
    end
    object CDSClienteOBSERVACAO: TWideMemoField
      FieldName = 'OBSERVACAO'
      Origin = 'CLIENTE.OBSERVACAO'
      ProviderFlags = [pfInUpdate]
      BlobType = ftWideMemo
      Size = 4
    end
    object CDSClienteRENDA_MENSAL: TBCDField
      FieldName = 'RENDA_MENSAL'
      Origin = 'CLIENTE.RENDA_MENSAL'
      currency = True
      Precision = 18
      Size = 2
    end
    object CDSClienteLIMITE_CREDITO: TBCDField
      FieldName = 'LIMITE_CREDITO'
      Origin = 'CLIENTE.LIMITE_CREDITO'
      currency = True
      Precision = 18
      Size = 2
    end
    object CDSClienteTOTAL_COMPRAS: TBCDField
      FieldName = 'TOTAL_COMPRAS'
      Origin = 'CLIENTE.TOTAL_COMPRAS'
      currency = True
      Precision = 18
      Size = 2
    end
  end
  object DsCliente: TDataSource
    DataSet = SqlCliente
    OnDataChange = DsClienteDataChange
    Left = 128
    Top = 88
  end
  object DSPCliente: TDataSetProvider
    DataSet = SqlCliente
    Left = 120
    Top = 160
  end
  object SqlProduto: TIBQuery
    Database = Conexao
    Transaction = IBTransaction1
    ForcedRefresh = True
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    SQL.Strings = (
      'select * from Produto order by codigo')
    UpdateObject = IBUpdateSQLProduto
    PrecommittedReads = False
    Left = 216
    Top = 80
    object SqlProdutoCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'PRODUTO.CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SqlProdutoDESCRICAO: TIBStringField
      FieldName = 'DESCRICAO'
      Origin = 'PRODUTO.DESCRICAO'
      Required = True
      Size = 60
    end
    object SqlProdutoREFERENCIA: TIBStringField
      FieldName = 'REFERENCIA'
      Origin = 'PRODUTO.REFERENCIA'
      Size = 10
    end
    object SqlProdutoCODIGO_BARRAS: TLargeintField
      FieldName = 'CODIGO_BARRAS'
      Origin = 'PRODUTO.CODIGO_BARRAS'
    end
    object SqlProdutoMARCA: TIBStringField
      FieldName = 'MARCA'
      Origin = 'PRODUTO.MARCA'
      Size = 30
    end
    object SqlProdutoGRUPO: TIBStringField
      FieldName = 'GRUPO'
      Origin = 'PRODUTO.GRUPO'
      Size = 30
    end
    object SqlProdutoPRECO_VENDA: TIBBCDField
      FieldName = 'PRECO_VENDA'
      Origin = 'PRODUTO.PRECO_VENDA'
      Required = True
      currency = True
      Precision = 18
      Size = 2
    end
    object SqlProdutoPRECO_CUSTO: TIBBCDField
      FieldName = 'PRECO_CUSTO'
      Origin = 'PRODUTO.PRECO_CUSTO'
      currency = True
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object SqlProdutoMARGEM_LUCRO: TIBBCDField
      FieldName = 'MARGEM_LUCRO'
      Origin = 'PRODUTO.MARGEM_LUCRO'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object SqlProdutoUND: TIBStringField
      FieldName = 'UND'
      Origin = 'PRODUTO.UND'
      Size = 6
    end
    object SqlProdutoESTOQUE_ATUAL: TIBBCDField
      FieldName = 'ESTOQUE_ATUAL'
      Origin = 'PRODUTO.ESTOQUE_ATUAL'
      DisplayFormat = '0.000'
      Precision = 18
      Size = 3
    end
  end
  object DsProduto: TDataSource
    DataSet = SqlProduto
    OnDataChange = DsProdutoDataChange
    Left = 304
    Top = 80
  end
  object CDSProduto: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPProduto'
    Left = 216
    Top = 160
  end
  object DSPProduto: TDataSetProvider
    DataSet = SqlProduto
    Left = 304
    Top = 160
  end
  object SqlVenda: TIBQuery
    Database = Conexao
    Transaction = IBTransaction1
    ForcedRefresh = True
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    SQL.Strings = (
      'select * from Venda')
    UpdateObject = IBUpdateSQLVenda
    PrecommittedReads = False
    Left = 32
    Top = 232
    object SqlVendaCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'VENDA.CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SqlVendaCODIGO_CLIENTE: TIntegerField
      FieldName = 'CODIGO_CLIENTE'
      Origin = 'VENDA.CODIGO_CLIENTE'
      Required = True
    end
    object SqlVendaSITUACAO: TIBStringField
      FieldName = 'SITUACAO'
      Origin = 'VENDA.SITUACAO'
      Required = True
      Size = 1
    end
    object SqlVendaDATA_HORA_VENDA: TDateTimeField
      FieldName = 'DATA_HORA_VENDA'
      Origin = 'VENDA.DATA_HORA_VENDA'
    end
    object SqlVendaTOTAL_BRUTO: TIBBCDField
      FieldName = 'TOTAL_BRUTO'
      Origin = 'VENDA.TOTAL_BRUTO'
      currency = True
      Precision = 18
      Size = 2
    end
    object SqlVendaDESCONTO_PERC: TIBBCDField
      FieldName = 'DESCONTO_PERC'
      Origin = 'VENDA.DESCONTO_PERC'
      DisplayFormat = '0.00'
      Precision = 18
      Size = 4
    end
    object SqlVendaACRESCIMO_PER: TIBBCDField
      FieldName = 'ACRESCIMO_PER'
      Origin = 'VENDA.ACRESCIMO_PER'
      DisplayFormat = '0.00'
      Precision = 18
      Size = 4
    end
    object SqlVendaTOTAL_LIQUIDO: TIBBCDField
      FieldName = 'TOTAL_LIQUIDO'
      Origin = 'VENDA.TOTAL_LIQUIDO'
      Required = True
      currency = True
      Precision = 18
      Size = 2
    end
    object SqlVendaNOMECLIENTTE: TStringField
      FieldKind = fkLookup
      FieldName = 'NOMECLIENTTE'
      LookupDataSet = SqlCliente
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'CODIGO_CLIENTE'
      Size = 100
      Lookup = True
    end
  end
  object CDSVenda: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPVenda'
    Left = 32
    Top = 296
  end
  object DSVenda: TDataSource
    DataSet = SqlVenda
    OnDataChange = DSVendaDataChange
    Left = 120
    Top = 232
  end
  object DSPVenda: TDataSetProvider
    DataSet = CDSVenda
    Left = 120
    Top = 296
  end
  object SQLVendaItem: TIBQuery
    Database = Conexao
    Transaction = IBTransaction1
    ForcedRefresh = True
    BufferChunks = 1000
    CachedUpdates = True
    DataSource = DSVenda
    ParamCheck = True
    SQL.Strings = (
      'select * from Venda_ITEM  WHERE CODIGO_VENDA = :CODIGO')
    UpdateObject = IBUpdateSQLVendaItem
    PrecommittedReads = False
    Left = 216
    Top = 232
    ParamData = <
      item
        DataType = ftInteger
        Name = 'CODIGO'
        ParamType = ptInput
      end>
    object SQLVendaItemCODIGO: TIntegerField
      AutoGenerateValue = arAutoInc
      DisplayLabel = 'Cod.Produto'
      DisplayWidth = 11
      FieldName = 'CODIGO'
      Origin = 'VENDA_ITEM.CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SQLVendaItemDescricaoProduto: TStringField
      DisplayLabel = 'Descri'#231#227'o do Produto'
      DisplayWidth = 35
      FieldKind = fkLookup
      FieldName = 'DescricaoProduto'
      LookupDataSet = SqlProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'CODIGO_PRODUTO'
      Size = 35
      Lookup = True
    end
    object SQLVendaItemQUANTIDADE: TIBBCDField
      DisplayLabel = 'Quantidade'
      DisplayWidth = 14
      FieldName = 'QUANTIDADE'
      Origin = 'VENDA_ITEM.QUANTIDADE'
      Required = True
      DisplayFormat = '0.000'
      Precision = 18
      Size = 3
    end
    object SQLVendaItemCODIGO_VENDA: TIntegerField
      DisplayWidth = 14
      FieldName = 'CODIGO_VENDA'
      Origin = 'VENDA_ITEM.CODIGO_VENDA'
      Required = True
    end
    object SQLVendaItemCODIGO_PRODUTO: TIntegerField
      DisplayWidth = 17
      FieldName = 'CODIGO_PRODUTO'
      Origin = 'VENDA_ITEM.CODIGO_PRODUTO'
      Required = True
    end
    object SQLVendaItemPrecoItem: TFloatField
      FieldKind = fkLookup
      FieldName = 'PrecoItem'
      LookupDataSet = SqlProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'PRECO_VENDA'
      KeyFields = 'CODIGO_PRODUTO'
      Lookup = True
    end
    object SQLVendaItemPRECO_UNITARIO: TIBBCDField
      DisplayWidth = 19
      FieldName = 'PRECO_UNITARIO'
      Origin = 'VENDA_ITEM.PRECO_UNITARIO'
      Required = True
      currency = True
      Precision = 18
      Size = 2
    end
    object SQLVendaItemDESCONTO: TIBBCDField
      DisplayWidth = 19
      FieldName = 'DESCONTO'
      Origin = 'VENDA_ITEM.DESCONTO'
      currency = True
      Precision = 18
      Size = 4
    end
    object SQLVendaItemACRESCIMO: TIBBCDField
      DisplayWidth = 19
      FieldName = 'ACRESCIMO'
      Origin = 'VENDA_ITEM.ACRESCIMO'
      currency = True
      Precision = 18
      Size = 4
    end
    object SQLVendaItemTOTAL_LIQUIDO: TIBBCDField
      DisplayWidth = 19
      FieldName = 'TOTAL_LIQUIDO'
      Origin = 'VENDA_ITEM.TOTAL_LIQUIDO'
      Required = True
      currency = True
      Precision = 18
      Size = 2
    end
  end
  object DSVendaItem: TDataSource
    DataSet = SQLVendaItem
    Left = 312
    Top = 232
  end
  object CDSVendaItem: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPVendaItem'
    Left = 216
    Top = 296
  end
  object DSPVendaItem: TDataSetProvider
    DataSet = CDSVendaItem
    Left = 312
    Top = 296
  end
  object QueryId: TIBQuery
    Database = Conexao
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 216
    Top = 8
  end
  object IBUpdateSQLCliente: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  NOME,'
      '  TIPO,'
      '  CPF,'
      '  CNPJ,'
      '  CEP,'
      '  ENDERECO,'
      '  NUMERO,'
      '  BAIRRO,'
      '  CIDADE,'
      '  TELEFONE,'
      '  OBSERVACAO,'
      '  RENDA_MENSAL,'
      '  LIMITE_CREDITO,'
      '  TOTAL_COMPRAS'
      'from CLIENTE '
      'where'
      '  CODIGO = :CODIGO')
    ModifySQL.Strings = (
      'update CLIENTE'
      'set'
      '  NOME = :NOME,'
      '  TIPO = :TIPO,'
      '  CPF = :CPF,'
      '  CNPJ = :CNPJ,'
      '  CEP = :CEP,'
      '  ENDERECO = :ENDERECO,'
      '  NUMERO = :NUMERO,'
      '  BAIRRO = :BAIRRO,'
      '  CIDADE = :CIDADE,'
      '  TELEFONE = :TELEFONE,'
      '  OBSERVACAO = :OBSERVACAO,'
      '  RENDA_MENSAL = :RENDA_MENSAL,'
      '  LIMITE_CREDITO = :LIMITE_CREDITO,'
      '  TOTAL_COMPRAS = :TOTAL_COMPRAS'
      'where'
      '  CODIGO = :OLD_CODIGO')
    InsertSQL.Strings = (
      'insert into CLIENTE'
      
        '  (NOME, TIPO, CPF, CNPJ, CEP, ENDERECO, NUMERO, BAIRRO, CIDADE, ' +
        'TELEFONE, '
      '   OBSERVACAO, RENDA_MENSAL, LIMITE_CREDITO, TOTAL_COMPRAS)'
      'values'
      
        '  (:NOME, :TIPO, :CPF, :CNPJ, :CEP, :ENDERECO, :NUMERO, :BAIRRO, ' +
        ':CIDADE, '
      '   :TELEFONE, :OBSERVACAO, :RENDA_MENSAL, :LIMITE_CREDITO, :TOTAL' +
        '_COMPRAS)')
    DeleteSQL.Strings = (
      'delete from CLIENTE'
      'where'
      '  CODIGO = :OLD_CODIGO')
    Left = 304
    Top = 8
  end
  object IBUpdateSQLProduto: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  DESCRICAO,'
      '  REFERENCIA,'
      '  CODIGO_BARRAS,'
      '  MARCA,'
      '  GRUPO,'
      '  PRECO_VENDA,'
      '  PRECO_CUSTO,'
      '  MARGEM_LUCRO,'
      '  UND,'
      '  ESTOQUE_ATUAL'
      'from PRODUTO '
      'where'
      '  CODIGO = :CODIGO')
    ModifySQL.Strings = (
      'update PRODUTO'
      'set'
      '  DESCRICAO = :DESCRICAO,'
      '  REFERENCIA = :REFERENCIA,'
      '  CODIGO_BARRAS = :CODIGO_BARRAS,'
      '  MARCA = :MARCA,'
      '  GRUPO = :GRUPO,'
      '  PRECO_VENDA = :PRECO_VENDA,'
      '  ESTOQUE_ATUAL = :ESTOQUE_ATUAL'
      'where'
      ' CODIGO = :OLD_CODIGO')
    InsertSQL.Strings = (
      'insert into PRODUTO'
      
        '  (DESCRICAO, REFERENCIA, CODIGO_BARRAS, MARCA, GRUPO, PRECO_VEN' +
        'DA, PRECO_CUSTO, MARGEM_LUCRO, UND, ESTOQUE_ATUAL)'
      'values'
      
        '  (:DESCRICAO, :REFERENCIA, :CODIGO_BARRAS, :MARCA, :GRUPO, :PRE' +
        'CO_VENDA, :PRECO_CUSTO, :MARGEM_LUCRO, :UND, :ESTOQUE_ATUAL)')
    DeleteSQL.Strings = (
      'delete from PRODUTO'
      'where'
      '  CODIGO = :OLD_CODIGO')
    Left = 416
    Top = 80
  end
  object IBUpdateSQLVenda: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  CODIGO_CLIENTE,'
      '  SITUACAO,'
      '  DATA_HORA_VENDA,'
      '  TOTAL_BRUTO,'
      '  DESCONTO_PERC,'
      '  ACRESCIMO_PER,'
      '  TOTAL_LIQUIDO'
      'from VENDA '
      'where'
      '  CODIGO = :CODIGO')
    ModifySQL.Strings = (
      'update VENDA'
      'set'
      '  CODIGO_CLIENTE = :CODIGO_CLIENTE,'
      '  SITUACAO = :SITUACAO,'
      '  DATA_HORA_VENDA = :DATA_HORA_VENDA,'
      '  TOTAL_BRUTO = :TOTAL_BRUTO,'
      '  DESCONTO_PERC = :DESCONTO_PERC,'
      '  ACRESCIMO_PER = :ACRESCIMO_PER,'
      '  TOTAL_LIQUIDO = :TOTAL_LIQUIDO'
      'where'
      '  CODIGO = :OLD_CODIGO')
    InsertSQL.Strings = (
      'insert into VENDA'
      
        '  (CODIGO_CLIENTE, SITUACAO, DATA_HORA_VENDA, TOTAL_BRUTO, DESCO' +
        'NTO_PERC, '
      '   ACRESCIMO_PER, TOTAL_LIQUIDO)'
      'values'
      
        '  (:CODIGO_CLIENTE, :SITUACAO, :DATA_HORA_VENDA, :TOTAL_BRUTO, :' +
        'DESCONTO_PERC, '
      '   :ACRESCIMO_PER, :TOTAL_LIQUIDO)')
    DeleteSQL.Strings = (
      'delete from VENDA'
      'where'
      '  CODIGO = :OLD_CODIGO')
    Left = 416
    Top = 160
  end
  object IBUpdateSQLVendaItem: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  CODIGO_VENDA,'
      '  CODIGO_PRODUTO,'
      '  QUANTIDADE,'
      '  PRECO_UNITARIO,'
      '  DESCONTO,'
      '  ACRESCIMO,'
      '  TOTAL_LIQUIDO'
      'from VENDA_ITEM '
      'where'
      '  CODIGO_VENDA = :CODIGO_VENDA and'
      '  CODIGO = :CODIGO')
    ModifySQL.Strings = (
      'update VENDA_ITEM'
      'set'
      '  CODIGO_VENDA = :CODIGO_VENDA,'
      '  CODIGO_PRODUTO = :CODIGO_PRODUTO,'
      '  QUANTIDADE = :QUANTIDADE,'
      '  PRECO_UNITARIO = :PRECO_UNITARIO,'
      '  DESCONTO = :DESCONTO,'
      '  ACRESCIMO = :ACRESCIMO,'
      '  TOTAL_LIQUIDO = :TOTAL_LIQUIDO'
      'where'
      ' CODIGO_VENDA = :OLD_CODIGO_VENDA and'
      '  CODIGO = :OLD_CODIGO'
      ''
      ''
      '')
    InsertSQL.Strings = (
      'insert into VENDA_ITEM'
      
        '  (CODIGO_VENDA, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO, DES' +
        'CONTO, '
      '   ACRESCIMO, TOTAL_LIQUIDO)'
      'values'
      
        '  (:CODIGO_VENDA, :CODIGO_PRODUTO, :QUANTIDADE, :PRECO_UNITARIO,' +
        ' :DESCONTO, '
      '   :ACRESCIMO, :TOTAL_LIQUIDO)')
    DeleteSQL.Strings = (
      'delete from VENDA_ITEM'
      'where'
      '  CODIGO_VENDA = :OLD_CODIGO_VENDA and'
      '  CODIGO = :OLD_CODIGO')
    Left = 416
    Top = 232
  end
end
