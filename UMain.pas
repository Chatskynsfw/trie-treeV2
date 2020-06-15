unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ActnList, StdCtrls, ImgList,
  ComCtrls, ToolWin,UNode,TrieTreeGUI;//UAdd, UDell, UFind,UTask;

type
  TFormMain = class(TForm)
    pnl1: TPanel;
    mainMenu: TMainMenu;
    nfile: TMenuItem;
    Edit: TMenuItem;
    Find: TMenuItem;
    Task: TMenuItem;
    Create: TMenuItem;
    Open: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    Ending: TMenuItem;
    Exit: TMenuItem;
    AddWord: TMenuItem;
    DeleteWord: TMenuItem;
    Clear: TMenuItem;
    dlgOpen: TOpenDialog;
    actlst: TActionList;
    tlb1: TToolBar;
    btnCreate: TToolButton;
    actCreate: TAction;
    btnOpen: TToolButton;
    actOpen: TAction;
    dlgSave: TSaveDialog;
    btnSave: TToolButton;
    actSave: TAction;
    btnSeparator1: TToolButton;
    btnAdd: TToolButton;
    actAdd: TAction;
    btnFind: TToolButton;
    actFind: TAction;
    btnDel: TToolButton;
    actDel: TAction;
    ImageLiist: TImageList;
    btnSeparator2: TToolButton;
    btnTask: TToolButton;
    actTask: TAction;
    btnSeparator3: TToolButton;
    btnClose: TToolButton;
    actClose: TAction;
    btnExit: TToolButton;
    actExit: TAction;
    treeMemo: TMemo;
    treeView: TTreeView;
    pnl2: TPanel;
    spl1: TSplitter;

    procedure Active(active:boolean);
    procedure AddWordClick(Sender: TObject);
    procedure DeleteWordClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CreateClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure TaskClick(Sender: TObject);
    procedure EndingClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure IdleWork(Sender: TObject; var Done: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  FileName: string;
  Tree:TTrieTreeGUI;
  treenode : TTreeNode;
  FileIsCreate, FileSave, FileClose: boolean;

implementation

{$R *.dfm}

procedure TformMain.IdleWork(Sender: Tobject; var Done: Boolean);
begin
  if (treeMemo.Lines.Count>0) then
    Active(true)

  else
    Active(false);
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
     Application.OnIdle := IdleWork;
end;

procedure TFormMain.Active(active:boolean);
  begin
    Clear.enabled:=active;
    DeleteWord.enabled:=active;
    Save.Enabled:=active;
    SaveAs.enabled:=active;
    DeleteWord.Enabled:=active;
    Clear.Enabled:=active;
    Ending.Enabled:=active;
    Task.Enabled:=active;
    Find.Enabled:=active;
    btnSave.Enabled:=active;
    btnDel.Enabled:=active;
    btnFind.Enabled:=active;
    btnClose.Enabled:=active;
    btnTask.Enabled:=active;
  end;

procedure TFormMain.AddWordClick(Sender: TObject);
var
  value : string;
begin
  if (Tree=nil) then
      Tree := TTrieTreeGUI.Create(treeMemo.Lines, treeview);

  if InputQuery('Добавление слова', 'Введите слово, которое нужно добавить', value) then
    Tree.Add(value);
end;

procedure TFormMain.DeleteWordClick(Sender: TObject);
var
  value:string;
begin
  if InputQuery('Удаление слова', 'Введите слово, которое нужно удалить', value) then
    Tree.Delete(value);
end;

procedure TFormMain.OpenClick(Sender: TObject);
begin
  if Tree.Save then
    begin
      treeMemo.Clear;
      treeView.Items.Clear;
      dlgOpen.FileName:=FileName;
      if dlgOpen.Execute then
        begin
          tree.LoadFromFile(dlgOpen.FileName);
          AddWord.Enabled:=true;
          btnAdd.Enabled:=true;
        end;
      end;
end;

procedure TFormMain.ExitClick(Sender: TObject);
begin
  if Tree.IsClosed then
    close();
end;

procedure TFormMain.SaveClick(Sender: TObject);
begin
  if FileName<>'' then
    Tree.SaveToFile(FileName)
  else
    SaveAsClick(Sender);
end;

procedure TFormMain.CreateClick(Sender: TObject);
begin
  if Tree.Save then
    begin
      treeMemo.Clear;
      treeView.Items.Clear;
      dlgSave.FileName:='';
      Filename:='';
      AddWord.Enabled:=true;
      btnAdd.Enabled:=true;
      AddWordClick(Sender);
    end;
end;

procedure TFormMain.FindClick(Sender: TObject);
var
  value : string;
begin
  if InputQuery('Поиск слова', 'Введите слово, которое нужно найти', value) then
    Tree.Find(value);
end;


procedure TFormMain.TaskClick(Sender: TObject);
var
  value : string;
begin
  if InputQuery('Задание', 'Удалить слова с заданной буквой. Введите букву', value) then
    Tree.Task(value);
end;

procedure TFormMain.EndingClick(Sender: TObject);
  begin
    Tree.IsClosed;
    Tree.Clear();
    treeMemo.Clear;
    TreeView.Items.Clear;
    AddWord.Enabled:=false;
    btnAdd.Enabled:=false;
  end;

procedure TFormMain.SaveAsClick(Sender: TObject);
  begin
    if dlgSave.Execute then
       Tree.SaveToFile(dlgSave.FileName);
  end;

procedure TFormMain.ClearClick(Sender: TObject);
  begin
    tree.Save;
    tree.Clear();
    treememo.Clear();
    treeview.Items.Clear;
    AddWord.Enabled:=false;
    btnAdd.Enabled:=false;
  end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Tree.IsClosed then
    Action:= caNone;
end;

procedure TFormMain.FormCreate(Sender: TObject);
  begin
    Tree := TTrieTreeGUI.Create(treeMemo.Lines, treeview);
  end;


initialization


finalization

end.
