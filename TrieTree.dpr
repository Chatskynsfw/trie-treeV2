program TrieTree;

uses
  Forms,
  UMain in 'UMain.pas' {FormMain},
  UNode in 'UNode.pas',
  //UAdd in 'UAdd.pas' {Form2},
  //UDell in 'UDell.pas' {Form3},
  UTrieTree in 'UTrieTree.pas',
  //UFind in 'UFind.pas' {Form4},
  //UTask in 'UTask.pas' {Form5},
  TrieTreeGUI in 'TrieTreeGUI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
 // Application.CreateForm(TForm2, Form2);
  //Application.CreateForm(TForm3, Form3);
  //Application.CreateForm(TForm4, Form4);
  //Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
