unit TrieTreeGUI;

interface
  uses Controls, Dialogs, ComCtrls, Classes, Forms, UNode, UTrieTree;
type
  TTrieTreeGUI = class(TTrie)
  private
    FFileName:string;
    FModified:Boolean;
    FLines:Tstrings;
    FTreeView:TTreeView;

  protected
    procedure SetModified(value:boolean);

  public
    constructor Create(aLines: tStrings; treeview:TTreeView);
    function LoadFromFile (AFileName : string):boolean; override;
    procedure SaveToFile (AFileName:string); override;
    procedure Clear;
    function Add (wrd : string):boolean; override;
    function Delete(wrd:string ):boolean; override;
    function Find(wrd:string):boolean; override;
    procedure Task(litter:string);
    function IsClosed:boolean;

    function Save:boolean;
    function SaveAs:boolean;
    property Filename : string  read FFileName write fFileName;
    property Modified : Boolean read FModified write SetModified;
  end;
var
  treenode : TTreeNode;
implementation

{ TTrieTreeGUI }

function TTrieTreeGUI.Add(wrd: string): boolean;
begin
  Result:= inherited Add(wrd);
  if result then
  begin
    FModified:=true;
    View(FLines);
    ViewInTV(FTreeView, treeNode);
  end;
end;

function TTrieTreeGUI.Delete(wrd: string): boolean;
begin
  Result:=inherited Delete(wrd);
  FModified:= Result or FModified;
  if  (FModified) then
  begin
    View(FLines);
    ViewInTV(FTreeView, treeNode);
  end;
end;

function TTrieTreeGUI.Find(wrd:string):boolean;
begin
   Result:=inherited Find(wrd);
   if Result then
      ShowMessage('Заданное слово найдено')
   else
      ShowMessage('Заданное слово не найдено')
end;

procedure TTrieTreeGUI.Task(litter:string);
var linesCount1:integer;
begin
  inherited Task(litter);
  linesCOunt1:=FLines.Count;
  View(FLines);
  ViewInTV(FTreeView, treeNode);
  Modified:= linesCOunt1<>FLines.Count;
end;

procedure TTrieTreeGUI.Clear;
begin
  if not IsEmpty then
  begin
    inherited Clear;
    Modified:= false;
  end;
end;

constructor TTrieTreeGUI.Create(aLines: tStrings; treeview:TTreeView);
begin
  inherited Create;
  FFileName:='';
  FModified:=False;
  fLines:= aLines;
  fTreeView:= treeview;
end;

function TTrieTreeGUI.Save;
var
  dlgRes: integer;
begin
  dlgRes:= MessageDlg('Сохранить изменения?',mtCustom,[mbYes,mbNo,mbCancel], 0);
  if dlgRes = mrCancel then
    Result:= false
  else if ((Modified) and (dlgRes = mrYes)) then
    begin
      if (FFileName <> '') then
        SaveToFile(FFileName)
      else
        SaveAs;
    end;
end;

function TTrieTreeGUI.SaveAs;
var dlgSave: TSaveDialog;
  begin
    if dlgSave.Execute then
      SaveToFile(dlgSave.FileName);
  end;

function TTrieTreeGUI.IsClosed:boolean;
begin
  Result:= save;
  if Result then
    clear();
end;

procedure TTrieTreeGUI.SetModified(value:boolean);
begin
  FModified:=value;
  if value then
    begin
      View(FLines);
      ViewInTV(FTreeView, treeNode);
    end;
end;

function TTrieTreeGUI.LoadFromFile(AFileName: string): boolean;
begin
  FFileName:=AFileName;
  Result:= inherited LoadFromFile(aFileName);
  FModified:=False;
  View(FLines);
  ViewInTV(FTreeView, treeNode);
end;

procedure TTrieTreeGUI.SaveToFile(AFileName: string);
begin
  inherited SaveToFile(AFileName);
  FFileName:=AFileName;
  FModified:=false;
end;

end.
 