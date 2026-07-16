program Projeto_Avaliacao;

uses
  Vcl.Forms,
  System.SysUtils,
  Principal in 'Principal.pas' {Form_Principal},
  DataModule in 'DataModule\DataModule.pas' {DM: TDataModule},
  Cliente in 'Cliente\Cliente.pas' {Form_Cliente},
  ClienteConsultaDoc in 'Cliente\ClienteConsultaDoc.pas',
  ConsultaCliente in 'Cliente\ConsultaCliente.pas' {Form_ConsultaCliente},
  Produto in 'Produto\Produto.pas' {Form_Produto},
  ConsultaProduto in 'Produto\ConsultaProduto.pas' {Form_ConsultaProduto},
  Venda in 'Venda\Venda.pas' {Form_Venda},
  CupomVenda in 'Venda\CupomVenda.pas' {Form_CupomVenda},
  Login in 'Login\Login.pas' {Form_Login},
  UsuarioAuth in 'Usuario\UsuarioAuth.pas',
  Usuario in 'Usuario\Usuario.pas' {Form_Usuario},
  RelatorioCliente in 'Relatorio\RelatorioCliente.pas' {Form_RelatorioCliente},
  RelatorioProduto in 'Relatorio\RelatorioProduto.pas' {Form_RelatorioProduto},
  RelatorioTabelaPrecos in 'Relatorio\RelatorioTabelaPrecos.pas' {Form_RelatorioTabelaPrecos},
  RelatorioLucratividade in 'Relatorio\RelatorioLucratividade.pas' {Form_RelatorioLucratividade},
  RelatorioVenda in 'Relatorio\RelatorioVenda.pas' {Form_RelatorioVenda},
  RelatorioVendaAnalitica in 'Relatorio\RelatorioVendaAnalitica.pas' {Form_RelatorioVendaAnalitica},
  RelatorioVendaCliente in 'Relatorio\RelatorioVendaCliente.pas' {Form_RelatorioVendaCliente},
  RelatorioVendaProduto in 'Relatorio\RelatorioVendaProduto.pas' {Form_RelatorioVendaProduto},
  RelatorioVendaSinteticaCliente in 'Relatorio\RelatorioVendaSinteticaCliente.pas' {Form_RelatorioVendaSinteticaCliente},
  RelatorioVendaClienteGrade in 'Relatorio\RelatorioVendaClienteGrade.pas' {Form_RelatorioVendaClienteGrade},
  EmiteEtiquetaProdutoGondula in 'Etiqueta\EmiteEtiquetaProdutoGondula.pas' {Form_EmiteEtiquetaProdutoGondula},
  EmiteEtiquetaCliente in 'Etiqueta\EmiteEtiquetaCliente.pas' {Form_EmiteEtiquetaCliente},
  RelatorioExportacaoFast in 'Relatorio\RelatorioExportacaoFast.pas',
  Mensagens in 'Mensagens.pas',
  UITheme in 'UI\UITheme.pas',
  LoadingBusy in 'UI\LoadingBusy.pas',
  Temas in 'Utilitario\Temas.pas' {Form_Temas},
  ObserveJson in 'Observabilidade\ObserveJson.pas',
  InteractionLogger in 'Observabilidade\InteractionLogger.pas',
  ObserveHooks in 'Observabilidade\ObserveHooks.pas',
  ScenarioPlayer in 'Observabilidade\ScenarioPlayer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  // Interaction Recorder: -observe ou PROJETO_OBSERVE=1
  // Em modo -replay tambem ativa o logger para registrar a execucao.
  if ObserveRequested or ReplayModeActive then
  begin
    InteractionLog.Start;
    ObserveInstall;
  end;
  // O DM vem antes do Form_Principal: o login (chamado no OnShow do
  // Principal) valida o usuario no banco.
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
  ObserveUninstall;
  InteractionLog.Stop;
end.
