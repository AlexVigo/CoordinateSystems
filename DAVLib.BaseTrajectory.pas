unit DAVLib.BaseTrajectory;

interface

uses
  DAVLib.CoordinateSystems, DAVLib.Types, System.Generics.Collections;

type
  TTimeInfo = record
    TimeStart, TimeEnd, TimeStep: Double;
    procedure Assign(Source: TTimeInfo);
  end;

  TBaseTrajectory = class(TObjectList<TCoordinates>)
  private
    FCoordSystem: TCoordSystem;
    procedure SetCoordSystem(const Value: TCoordSystem);
    function GetTimeStart: Double;
    function GetTimeEnd: Double;
    function GetTimeStep: Double;
  public
    procedure AddPoint(const Sourse: TCoordinates);
    procedure AddXYZ(const aX, aY, aZ: Double; aTime: Double = 0);
    procedure AddDBZ(const aD, aB, aZ: Double; aTime: Double = 0);
    procedure AddRBE(const aR, aB, aE: Double; aTime: Double = 0; aVr: Double = 0);
    procedure AddXYZTrajectory(const aX, aY, aZ: TDoubleDynArray; aTime: TDoubleDynArray = nil);
    procedure AddDBZTrajectory(const aD, aB, aZ: TDoubleDynArray; aTime: TDoubleDynArray = nil);
    procedure AddRBETrajectory(const aR, aB, aE: TDoubleDynArray; aTime: TDoubleDynArray = nil);
{ MaxValue: Returns the largest signed value in the data trajectory (MAX) }
    function MaxValX: Double;
    function MaxValY: Double;
    function MaxValZ: Double;
    function MaxValR: Double;
    function MaxValB: Double;
    function MaxValE: Double;
    function MaxValD: Double;
    function MaxValVr: Double;
    function MaxValT: Double;
{ MinValue: Returns the smallest signed value in the data trajectory (MIN) }
    function MinValX: Double;
    function MinValY: Double;
    function MinValZ: Double;
    function MinValR: Double;
    function MinValB: Double;
    function MinValE: Double;
    function MinValD: Double;
    function MinValVr: Double;
    function MinValT: Double;
    function XArray: TDoubleDynArray;
    function YArray: TDoubleDynArray;
    function ZArray: TDoubleDynArray;
    function RArray: TDoubleDynArray;
    function BArray: TDoubleDynArray;
    function EArray: TDoubleDynArray;
    function DArray: TDoubleDynArray;
    function TArray: TDoubleDynArray;
    function VrArray: TDoubleDynArray;
    procedure Assign(const Source: TBaseTrajectory);
    // override to assign additional data in childrens
    procedure AssignInfo(const Source: TBaseTrajectory); virtual;
    procedure AssignCoordinates(const Source: TBaseTrajectory);
    procedure Reverse(ReverseWithTime: Boolean = False);
    property CoordinateSystem: TCoordSystem read FCoordSystem write SetCoordSystem;
    constructor Create();
  public
    TimeInfo: TTimeInfo;
    procedure SetTimeParams(); overload;
    procedure ÑalcSpeed();
    procedure SetTimeParams(const aTimeInfo: TTimeInfo); overload;
    property TimeStart: Double read GetTimeStart;
    property TimeEnd: Double read GetTimeEnd;
    property TimeStep: Double read GetTimeStep;
    procedure SortByTime();
    function PreLast(): TCoordinates;
  end;

implementation

uses
  System.SysUtils, System.Math, System.Generics.Defaults;

{ TTimeInfo }

procedure TTimeInfo.Assign(Source: TTimeInfo);
begin
  Self.TimeStart := Source.TimeStart;
  Self.TimeEnd := Source.TimeEnd;
  Self.TimeStep := Source.TimeStep;
end;

{ TBaseTrajectoryClass }

procedure TBaseTrajectory.AddDBZ(const aD, aB, aZ: Double; aTime: Double);
begin
  CoordinateSystem := csCylindrical;
  Self.Add(TCoordinates.CreateDBZ(aD, aB, aZ, aTime));
end;

procedure TBaseTrajectory.AddDBZTrajectory(const aD, aB, aZ: TDoubleDynArray; aTime: TDoubleDynArray);
var
  I, LLength: Integer;
  LTimeVector: TDoubleDynArray;
begin
  CoordinateSystem := csCylindrical;
  LLength := Length(aD);
  if length(aTime) = 0 then
    SetLength(LTimeVector, LLength)
  else
    LTimeVector := Copy(aTime);

  if (LLength <> Length(aB)) or (LLength <> Length(aZ)) or (LLength <> Length(LTimeVector)) then
    raise ECoordSystemError.Create('RangeCheckError: Check size!');

  Self.Clear;
  for I := 0 to LLength - 1 do
  begin
    Self.AddDBZ(aD[I], aB[I], aZ[I], LTimeVector[I]);
  end;
end;

procedure TBaseTrajectory.AddPoint(const Sourse: TCoordinates);
begin
  CoordinateSystem := Sourse.CoordinateSystem;
  Self.Add(TCoordinates.CreatePoint(Sourse));
end;

procedure TBaseTrajectory.AddRBE(const aR, aB, aE: Double; aTime: Double; aVr: Double);
begin
  CoordinateSystem := csSpherical;
  Self.Add(TCoordinates.CreateRBE(aR, aB, aE, aTime, aVr));
end;

procedure TBaseTrajectory.AddRBETrajectory(const aR, aB, aE: TDoubleDynArray; aTime: TDoubleDynArray);
var
  I, LLength: Integer;
  LTimeVector: TDoubleDynArray;
begin
  CoordinateSystem := csSpherical;
  LLength := Length(aR);
  if length(aTime) = 0 then
    SetLength(LTimeVector, LLength)
  else
    LTimeVector := Copy(aTime);

  if (LLength <> Length(aB)) or (LLength <> Length(aE)) or (LLength <> Length(LTimeVector)) then
    raise ECoordSystemError.Create('RangeCheckError: Check size!');

  Self.Clear;
  for I := 0 to LLength - 1 do
  begin
    Self.AddRBE(aR[I], aB[I], aE[I], LTimeVector[I]);
  end;
end;

procedure TBaseTrajectory.AddXYZ(const aX, aY, aZ: Double; aTime: Double);
begin
  CoordinateSystem := csCartesian;
  Self.Add(TCoordinates.CreateXYZ(aX, aY, aZ, aTime));
end;

procedure TBaseTrajectory.AddXYZTrajectory(const aX, aY, aZ: TDoubleDynArray; aTime: TDoubleDynArray);
var
  I, LLength: Integer;
  LTimeVector: TDoubleDynArray;
begin
  CoordinateSystem := csCartesian;
  LLength := Length(aX);
  if length(aTime) = 0 then
    SetLength(LTimeVector, LLength)
  else
    LTimeVector := Copy(aTime);

  if (LLength <> Length(aY)) or (LLength <> Length(aZ)) or (LLength <> Length(LTimeVector)) then
    raise ECoordSystemError.Create('RangeCheckError: Check size!');

  Self.Clear;
  for I := 0 to LLength - 1 do
  begin
    Self.AddXYZ(aX[I], aY[I], aZ[I], LTimeVector[I]);
  end;
end;

procedure TBaseTrajectory.Assign(const Source: TBaseTrajectory);
begin
  Self.AssignCoordinates(Source);
  Self.AssignInfo(Source);
end;

procedure TBaseTrajectory.AssignCoordinates(const Source: TBaseTrajectory);
var
  i: Integer;
begin
  FCoordSystem := Source.FCoordSystem;
  Self.Clear;
  for i := 0 to Source.Count - 1 do
    Self.Add(TCoordinates.CreatePoint(Source[i]));
end;

procedure TBaseTrajectory.AssignInfo(const Source: TBaseTrajectory);
begin
  Self.SetTimeParams(Source.TimeInfo);
end;

procedure TBaseTrajectory.SetTimeParams();
begin
  if Self.Count < 2 then
    raise ECoordSystemError.Create('SetTimeParamError: Need at least 2 coordinates to set time params!');

  Self.TimeInfo.TimeStart := Self.First.T;
  Self.TimeInfo.TimeEnd := Self.Last.T;
  Self.TimeInfo.TimeStep := (Self.TimeInfo.TimeEnd - Self.TimeInfo.TimeStart) / (Self.Count - 1);
end;

procedure TBaseTrajectory.ÑalcSpeed();
var
  i: Integer;
begin
  if Self.Count < 2 then
    raise ECoordSystemError.Create('SetTimeParamError: Need at least 2 coordinates to set time params!');

  for i := 1 to Self.Count - 1 do
    Self[i].Vr := (Self[i - 1].R - Self[i].R) / (Self[i].T - Self[i - 1].T);

  Self.First.Vr := Self[1].Vr;
end;

procedure TBaseTrajectory.SetTimeParams(const aTimeInfo: TTimeInfo);
begin
  Self.TimeInfo.TimeStart := aTimeInfo.TimeStart;
  Self.TimeInfo.TimeEnd := aTimeInfo.TimeEnd;
  Self.TimeInfo.TimeStep := aTimeInfo.TimeStep;
end;

function compareByTime(const Item1, Item2: TCoordinates): Integer;
begin
  Result := CompareValue(Item1.T, Item2.T);
end;

procedure TBaseTrajectory.SortByTime;
begin
  Sort(TComparer<TCoordinates>.Construct(compareByTime));
end;

function TBaseTrajectory.GetTimeStart: Double;
begin
  Result := TimeInfo.TimeStart;
end;

function TBaseTrajectory.GetTimeEnd: Double;
begin
  Result := TimeInfo.TimeEnd;
end;

function TBaseTrajectory.GetTimeStep: Double;
begin
  Result := TimeInfo.TimeStep;
end;

function TBaseTrajectory.PreLast: TCoordinates;
begin
  Result := Self[Count - 2];
end;

function TBaseTrajectory.BArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].B;
end;

constructor TBaseTrajectory.Create;
begin
  inherited Create(True);
end;

function TBaseTrajectory.DArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].D;
end;

function TBaseTrajectory.EArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].E;
end;

function TBaseTrajectory.MaxValB: Double;
var
  i: Integer;
begin
  Result := Self[0].B;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].B then
      Result := Self[i].B;
end;

function TBaseTrajectory.MaxValD: Double;
var
  i: Integer;
begin
  Result := Self[0].D;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].D then
      Result := Self[i].D;
end;

function TBaseTrajectory.MaxValE: Double;
var
  i: Integer;
begin
  Result := Self[0].E;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].E then
      Result := Self[i].E;
end;

function TBaseTrajectory.MaxValR: Double;
var
  i: Integer;
begin
  Result := Self[0].R;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].R then
      Result := Self[i].R;
end;

function TBaseTrajectory.MaxValT: Double;
var
  i: Integer;
begin
  Result := Self[0].T;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].T then
      Result := Self[i].T;
end;

function TBaseTrajectory.MaxValVr: Double;
var
  I: Integer;
begin
  Result := Self[0].Vr;
  for I := 1 to Self.Count - 1 do
    if Result < Self[I].Vr then
      Result := Self[I].Vr;
end;

function TBaseTrajectory.MaxValX: Double;
var
  i: Integer;
begin
  Result := Self[0].X;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].X then
      Result := Self[i].X;
end;

function TBaseTrajectory.MaxValY: Double;
var
  i: Integer;
begin
  Result := Self[0].Y;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].Y then
      Result := Self[i].Y;
end;

function TBaseTrajectory.MaxValZ: Double;
var
  i: Integer;
begin
  Result := Self[0].Z;
  for i := 1 to Self.Count - 1 do
    if Result < Self[i].Z then
      Result := Self[i].Z;
end;

function TBaseTrajectory.MinValB: Double;
var
  i: Integer;
begin
  Result := Self[0].B;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].B then
      Result := Self[i].B;
end;

function TBaseTrajectory.MinValD: Double;
var
  i: Integer;
begin
  Result := Self[0].D;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].D then
      Result := Self[i].D;
end;

function TBaseTrajectory.MinValE: Double;
var
  i: Integer;
begin
  Result := Self[0].E;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].E then
      Result := Self[i].E;
end;

function TBaseTrajectory.MinValR: Double;
var
  i: Integer;
begin
  Result := Self[0].R;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].R then
      Result := Self[i].R;
end;

function TBaseTrajectory.MinValT: Double;
var
  i: Integer;
begin
  Result := Self[0].T;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].T then
      Result := Self[i].T;
end;

function TBaseTrajectory.MinValVr: Double;
var
  I: Integer;
begin
  Result := Self[0].Vr;
  for I := 1 to Self.Count - 1 do
    if Result > Self[I].Vr then
      Result := Self[I].Vr;
end;

function TBaseTrajectory.MinValX: Double;
var
  i: Integer;
begin
  Result := Self[0].X;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].X then
      Result := Self[i].X;
end;

function TBaseTrajectory.MinValY: Double;
var
  i: Integer;
begin
  Result := Self[0].Y;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].Y then
      Result := Self[i].Y;
end;

function TBaseTrajectory.MinValZ: Double;
var
  i: Integer;
begin
  Result := Self[0].Z;
  for i := 1 to Self.Count - 1 do
    if Result > Self[i].Z then
      Result := Self[i].Z
end;

function TBaseTrajectory.RArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].R;
end;

procedure TBaseTrajectory.SetCoordSystem(const Value: TCoordSystem);
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

function TBaseTrajectory.TArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].T;
end;

function TBaseTrajectory.VrArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].Vr;
end;

procedure TBaseTrajectory.Reverse(ReverseWithTime: Boolean);
var
  i, N: Integer;
  LTemp: TCoordinates;
  LTime: Double;
begin
  LTemp := TCoordinates.Create();
  N := Self.Count;
  try
    for i := 0 to Trunc(N / 2) - 1 do
    begin
      LTemp.Assign(Self[i]);
      Self[i].Assign(Self[N - i - 1]);
      Self[N - i - 1].Assign(LTemp);
      if ReverseWithTime then
      begin
        LTime := Self[i].T;
        Self[i].T := Self[N - i - 1].T;
        Self[N - i - 1].T := LTime;
      end;
    end;
  finally
    FreeAndNil(LTemp);
  end;
end;

function TBaseTrajectory.XArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].X;
end;

function TBaseTrajectory.YArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].Y;
end;

function TBaseTrajectory.ZArray: TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, Self.Count);
  for I := 0 to High(Result) do
    Result[I] := Self[I].Z;
end;

end.

