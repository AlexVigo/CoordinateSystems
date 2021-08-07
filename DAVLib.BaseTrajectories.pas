unit DAVLib.BaseTrajectories;

interface

uses
  DAVLib.BaseTrajectory, System.Generics.Collections,
  DAVLib.CoordinateSystems, DAVLib.Types;

type
  TBaseTrajectoryClass = class of TBaseTrajectory;

  TBaseTrajectories = class(TObjectList<TBaseTrajectory>)
  private
    FCoordSystem: TCoordSystem;
    procedure SetCoordSystem(const Value: TCoordSystem);
    function GetTimeStep: Double;
    function GetTimeEnd: Double;
    function GetTimeStart: Double;
  public
    constructor Create(OwnsObjects: Boolean = True);
    procedure Add(ATrajectoryClassType: TBaseTrajectoryClass); overload;
    procedure Add; overload;
    procedure Add(aCount: Integer); overload;
    function GetMaxPointCount: Integer;
{ MaxValue: Returns the largest signed value in the data trajectory (MAX) }
    function MaxValX: Double;
    function MaxValY: Double;
    function MaxValZ: Double;
    function MaxValR: Double;
    function MaxValB: Double;
    function MaxValE: Double;
    function MaxValD: Double;
    function MaxValT: Double;
{ MinValue: Returns the smallest signed value in the data trajectory (MIN) }
    function MinValX: Double;
    function MinValY: Double;
    function MinValZ: Double;
    function MinValR: Double;
    function MinValB: Double;
    function MinValE: Double;
    function MinValD: Double;
    function MinValT: Double;
    function XMatrix: TDoubleDynMatrix;
    function YMatrix: TDoubleDynMatrix;
    function ZMatrix: TDoubleDynMatrix;
    function RMatrix: TDoubleDynMatrix;
    function BMatrix: TDoubleDynMatrix;
    function EMatrix: TDoubleDynMatrix;
    function DMatrix: TDoubleDynMatrix;
    function TMatrix: TDoubleDynMatrix;
    procedure Copy(const Source: TBaseTrajectories);
    procedure Assign(const Source: TBaseTrajectories);
    // override to assign additional data in childrens
    procedure AssignInfo(const Source: TBaseTrajectories); virtual;
    procedure AssignCoordinates(const Source: TBaseTrajectories);
    procedure Reverse(ReverseWithTime: Boolean = False);
    property CoordinateSystem: TCoordSystem read FCoordSystem write SetCoordSystem;
    property TimeStart: Double read GetTimeStart;
    property TimeStep: Double read GetTimeStep;
    property TimeEnd: Double read GetTimeEnd;
  end;

implementation

procedure TBaseTrajectories.Add(ATrajectoryClassType: TBaseTrajectoryClass);
begin
  Self.Add(ATrajectoryClassType.Create);
end;

procedure TBaseTrajectories.Add;
begin
  Self.Add(TBaseTrajectory);
end;

procedure TBaseTrajectories.Add(aCount: Integer);
var i: Integer;
begin
  for i := 0 to aCount-1 do
    Self.Add;
end;

procedure TBaseTrajectories.Assign(const Source: TBaseTrajectories);
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Self[I].Assign(Source[I]);
end;

procedure TBaseTrajectories.AssignCoordinates(const Source: TBaseTrajectories);
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Self[I].AssignCoordinates(Source[I]);
end;

procedure TBaseTrajectories.AssignInfo(const Source: TBaseTrajectories);
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Self[I].AssignInfo(Source[I]);
end;

function TBaseTrajectories.BMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].BArray;
end;

procedure TBaseTrajectories.Copy(const Source: TBaseTrajectories);
var i: Integer;
begin
  Self.Clear;
  for i := 0 to Source.Count-1  do
  begin
    Self.Add();
    Self[i].AssignCoordinates(Source[i]);
    if Self[i].Count > 1  then
    begin
      Self[i].SetTimeParams();
      Self[i].ÑalcSpeed();
    end
    else
      Assert(False, 'SetTimeParamError: Need at least 2 coordinates to set time params!');
  end;
end;

constructor TBaseTrajectories.Create(OwnsObjects: Boolean);
begin
  inherited Create(OwnsObjects);
end;

function TBaseTrajectories.GetMaxPointCount: Integer;
var
  i: Integer;
begin
  Result := Self[0].Count;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].Count then
      Result := Self[i].Count;
end;

function TBaseTrajectories.DMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].DArray;
end;

function TBaseTrajectories.EMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].EArray;
end;

function TBaseTrajectories.GetTimeEnd: Double;
var
  i: Integer;
begin
  Result := Self[0].TimeEnd;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].TimeEnd then
      Result := Self[i].TimeEnd;

end;

function TBaseTrajectories.GetTimeStart: Double;
var
  i: Integer;
begin
  Result := Self[0].TimeStart;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].TimeStart then
      Result := Self[i].TimeStart;
end;

function TBaseTrajectories.GetTimeStep: Double;
var
  i: Integer;
begin
  Result := Self[0].TimeStep;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].TimeStep then
      Result := Self[i].TimeStep;
end;

function TBaseTrajectories.MaxValB: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValB;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValB then
      Result := Self[i].MaxValB;
end;

function TBaseTrajectories.MaxValD: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValD;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValD then
      Result := Self[i].MaxValD;
end;

function TBaseTrajectories.MaxValE: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValE;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValE then
      Result := Self[i].MaxValE;
end;

function TBaseTrajectories.MaxValR: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValR;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValR then
      Result := Self[i].MaxValR
end;

function TBaseTrajectories.MaxValT: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValT;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValT then
      Result := Self[i].MaxValT;
end;

function TBaseTrajectories.MaxValX: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValX;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValX then
      Result := Self[i].MaxValX;
end;

function TBaseTrajectories.MaxValY: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValY;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValY then
      Result := Self[i].MaxValY
end;

function TBaseTrajectories.MaxValZ: Double;
var
  i: Integer;
begin
  Result := Self[0].MaxValZ;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].MaxValZ then
      Result := Self[i].MaxValZ
end;

function TBaseTrajectories.MinValB: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValB;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValB then
      Result := Self[i].MinValB;
end;

function TBaseTrajectories.MinValD: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValD;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValD then
      Result := Self[i].MinValD;
end;

function TBaseTrajectories.MinValE: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValE;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValE then
      Result := Self[i].MinValE;
end;

function TBaseTrajectories.MinValR: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValR;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValR then
      Result := Self[i].MinValR;
end;

function TBaseTrajectories.MinValT: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValT;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValT then
      Result := Self[i].MinValT;
end;

function TBaseTrajectories.MinValX: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValX;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValX then
      Result := Self[i].MinValX;
end;

function TBaseTrajectories.MinValY: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValY;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValY then
      Result := Self[i].MinValY;
end;

function TBaseTrajectories.MinValZ: Double;
var
  i: Integer;
begin
  Result := Self[0].MinValZ;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].MinValZ then
      Result := Self[i].MinValZ;
end;

procedure TBaseTrajectories.Reverse(ReverseWithTime: Boolean);
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Self[I].Reverse(ReverseWithTime);
end;

function TBaseTrajectories.RMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].RArray;
end;

procedure TBaseTrajectories.SetCoordSystem(const Value: TCoordSystem);
var
  I: Integer;
begin
  if FCoordSystem <> Value then
  begin
    for I := 0 to Self.Count - 1 do
      Self.Items[I].CoordinateSystem := Value;
    FCoordSystem := Value;
  end;
end;

function TBaseTrajectories.TMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].TArray;
end;

function TBaseTrajectories.XMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].XArray;
end;

function TBaseTrajectories.YMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].YArray;
end;

function TBaseTrajectories.ZMatrix: TDoubleDynMatrix;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].ZArray;
end;

end.

