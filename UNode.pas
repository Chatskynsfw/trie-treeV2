unit UNode;

interface
  uses Windows, Messages, SysUtils, Math, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

const LowCh = 'a';
      HighCh = 'z';
type
  TIndex = LowCh..HighCh;
  TNode = class
    private
      FPoint: boolean;
      FNext: array [TIndex] of TNode;

    protected
      function GetNext (index: TIndex): TNode;
      procedure SetNext(value:tIndex; aNode:TNode);

    public
      Constructor Create;
      Destructor Destroy;  override;
      function IsEmpty(): boolean;
      function Add (wrd: string):boolean;
      function Delete (var wrd: string): boolean;
      function Find(wrd:string):boolean;
      procedure ViewInTV (treeview:TTreeView;treeNode:TTReeNode);
      class function CheckWord(wrd:string):boolean;
      function Task(wrd,litter: string; var found:boolean): boolean;
      procedure View(str:Tstrings; wrd:string);

      property Point:boolean read FPoint write FPoint;
      property Next[value:TIndex]:tNode read GetNext write SetNext;
  end;

implementation

constructor TNode.Create;
var i: TIndex;
  begin
    inherited Create;
    FPoint:= false;
    for i := LowCh to HighCh do
      FNext[i]:=nil;
  end;

destructor TNode.Destroy;
var i: TIndex;
  begin
    for i := LowCh to HighCh do
      FNext[i].Free;

    inherited Destroy;
  end;
             
function TNode.IsEmpty():boolean;
var i: TIndex;
  begin
    i:=LowCh;
    result:=not FPoint and (FNext[i]=nil);
    if result then
      repeat
         inc(i);
         result:=FNext[i]=nil;
      until  not result or (i=HighCh);
  end;

function TNode.Add (wrd: string):boolean;
var f:TIndex;
  begin
    if wrd='' then
      begin
        result:=not FPoint;
        FPoint:=true;
      end

    else
      begin
        f:=wrd[1];          
        System.Delete(wrd,1,1);
        if FNext[f]=nil then
          FNext[f]:=TNode.Create;

        result:=FNext[f].Add(wrd);
      end;
  end;

function TNode.Delete(var wrd: string): boolean;
var f:tIndex;
  begin
    if wrd='' then
      begin
        result:=FPoint;
        FPoint:=false
      end

    else
      begin
        f:=wrd[1];
        System.Delete(wrd,1,1);
        result:=(FNext[f]<>nil) and FNext[f].Delete(wrd);
        if result and FNext[f].IsEmpty then
          FReeandNil(FNext[f]);

      end
  end;

function TNode.Find(wrd:string):boolean;
  begin
    if wrd='' then
      result:= FPoint

    else
      result:=(FNext[wrd[1]]<>nil)and FNext[wrd[1]].Find(copy(wrd,2,length(wrd)-1));
  end;

function TNode.GetNext(index: TIndex):TNode;
  begin
      result:=FNext[index]
  end;

procedure TNode.SetNext(value:tIndex; aNode:TNode);
  begin
    if FNext[value]<>aNode then
      begin
        FNext[value].Free;
        FNext[value]:=ANode;
      end;
  end;

procedure TNode.ViewInTV(treeview:TTreeView; treeNode:TTReeNode);
var i:TIndex;
    newnode : TTreeNode;
  begin
    for i:=LowCh to HighCh do
      if FNext[i]<>nil then
      begin
        newnode:= TreeView.Items.AddChild(treenode,i);
        if FNext[i].FPoint then
         TreeView.Items.AddChild(newnode,'*');
        FNext[i].ViewInTV(treeview, newnode);

      end;
      treeView.FullExpand;
  end;

procedure TNode.View(str:Tstrings; wrd:string);
var i:TIndex;
  begin
    if FPoint then
      str.Add(wrd);
    for i:=LowCh to HighCh do
      if FNext[i]<>nil then
        FNext[i].View(str,wrd+i);
  end;

class function TNode.CheckWord(wrd:string):boolean;
var i:integer;
  begin
    i:=1;
    while (i<length(wrd)) and (wrd[i] in [LowCh..HighCh]) do
      inc(i);
    result:=(i=length(wrd)) and (wrd[i] in [LowCh..HighCh])
  end;

//function TNode.Task(wrd,litter: string; found:boolean): boolean;
//var i: TIndex; j: integer; str:string;
  //begin
     {if FPoint then
     begin
       j:=1;
       while (j<=length(wrd)) do
         begin
            if (wrd[j]=litter) then
            FPoint:=false;
            inc(j);
         end;
     end;
     for i:= LowCh to HighCh do
     begin
        if FNext[i]<>nil then
          if FNext[i].Task(wrd+i,litter, found) then
              FNext[i]:=nil;
     end;

       if  IsEmpty() then
        begin
          Delete(wrd);
          result:=true;

        end
     else
        result:=false;   }

     {
     for i:= LowCh to HighCh do
     begin
        if FNext[i]<>nil then
        begin
          if i=litter then
          begin
            found:=true;
            FPoint:=false;
            end;
          if FNext[i].Task(wrd+i,litter, found) then
            begin
              FNext[i]:=nil;
            end;
              end;
      end;
       if  found then
        begin
          showmessage(wrd);
          Delete(wrd);

          result:=true;

        end

     else
        result:=false;
       //found:=false;}
function TNode.Task(wrd,litter: string; var found:boolean): boolean;
var i: TIndex; tmp: boolean;
begin
  if FPoint and found then
      FPoint:=false;

  for i:= LowCh to HighCh do
    begin
      if (i = litter) or found then
        tmp := true

      else
        tmp := false;

      if FNext[i]<>nil then
        begin
          if FNext[i].Task(wrd+i,litter, tmp) then
            FNext[i]:=nil;
        end
    end;

      if IsEmpty() then
        begin
          Delete(wrd);
          result:=true;
        end
      else
        result:=false;
end;
end.
