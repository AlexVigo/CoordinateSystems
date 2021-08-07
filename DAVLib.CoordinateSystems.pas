unit DAVLib.CoordinateSystems;

/// <summary>
/// Library for different coordinate system transition
/// Supported Cartesian, Cylindrical, Spherical coordinate systems
/// </summary>

interface

uses
  System.SysUtils;

type
  ECoordSystemError = class(Exception);
  TCoordSystem = (csCartesian, csCylindrical, csSpherical);
  TCoordSystemDefaultSet = set of TCoordSystem;

var
  CoordSystemDefaultSet: TCoordSystemDefaultSet; // for transition in case of ambiguity
  //By default if Set "B" at csCartesian -> csCylindrical
  //By default if Set "Z" at csSpherical -> csCartesian

  type
  TCoordinates = class
  private
    FCoordSystem: TCoordSystem;
    FData_0, FData_1, FData_2: Double;
 //    X        Y        Z
 //    D        B        Z
 //    R        B        E
    FData_3: Double; // Time
    FData_4: Double; // Speed (Velosity) radial
    FTag: Integer;
    procedure SetB(const Value: Double);
    procedure SetD(const Value: Double);
    procedure SetE(const Value: Double);
    procedure SetR(const Value: Double);
    procedure SetT(const Value: Double);
    procedure SetX(const Value: Double);
    procedure SetY(const Value: Double);
    procedure SetZ(const Value: Double);
    function GetB: Double;
    function GetD: Double;
    function GetE: Double;
    function GetR: Double;
    function GetT: Double;
    function GetX: Double;
    function GetY: Double;
    function GetZ: Double;
    function GetVr: Double;
    procedure SetVr(const Value: Double);
    procedure SetCoordSystem(const Value: TCoordSystem);
  public
    class function CreatePoint(Sourse: TCoordinates): TCoordinates;
    class function CreateXYZ(const aX, aY, aZ: Double; aTime: Double = 0): TCoordinates; static;
    class function CreateDBZ(const aD, aB, aZ: Double; aTime: Double = 0): TCoordinates; static;
    class function CreateRBE(const aR, aB, aE: Double; aTime: Double = 0; aVr: Double = 0): TCoordinates; static;
    procedure SetPoint(Sourse: TCoordinates);
    procedure SetXYZ(const aX, aY, aZ: Double; aTime: Double = 0);
    procedure SetDBZ(const aD, aB, aZ: Double; aTime: Double = 0);
    procedure SetRBE(const aR, aB, aE: Double; aTime: Double = 0);
    property X: Double read GetX write SetX;
    property Y: Double read GetY write SetY;
    property Z: Double read GetZ write SetZ;
    property R: Double read GetR write SetR;
    property B: Double read GetB write SetB;
    property E: Double read GetE write SetE;
    property D: Double read GetD write SetD;
    property T: Double read GetT write SetT; // Time
    property Vr: Double read GetVr write SetVr; // Speed (Velosity) radial
    property Tag: Integer read FTag write FTag;
    property CoordinateSystem: TCoordSystem read FCoordSystem write SetCoordSystem;
    procedure Assign(Source: TCoordinates); virtual;
    constructor Create();
    destructor Destroy(); override;
  end;

implementation

uses
  System.Math;

{ TCoordinates }

procedure TCoordinates.Assign(Source: TCoordinates);
begin
  Self.FCoordSystem := Source.FCoordSystem;
  Self.FData_0 := Source.FData_0;
  Self.FData_1 := Source.FData_1;
  Self.FData_2 := Source.FData_2;
  Self.FData_3 := Source.FData_3;
  Self.FData_4 := Source.FData_4;
  Self.Tag := Source.Tag;
end;

constructor TCoordinates.Create;
begin
  inherited Create;
  FTag := 0;
end;

class function TCoordinates.CreateDBZ(const aD, aB, aZ: Double; aTime: Double): TCoordinates;
begin
  Result := TCoordinates.Create;
  Result.FCoordSystem := csCylindrical;
  Result.FData_0 := aD;
  Result.FData_1 := aB;
  Result.FData_2 := aZ;
  Result.FData_3 := aTime;
  Result.FData_4 := aTime;
end;

procedure TCoordinates.SetDBZ(const aD, aB, aZ: Double; aTime: Double);
begin
  Self.FCoordSystem := csCylindrical;
  Self.FData_0 := aD;
  Self.FData_1 := aB;
  Self.FData_2 := aZ;
  Self.FData_3 := aTime;
  Self.FData_4 := aTime;
end;

class function TCoordinates.CreateRBE(const aR, aB, aE: Double;
                                            aTime: Double; aVr: Double): TCoordinates;
begin
  Result := TCoordinates.Create;
  Result.FCoordSystem := csSpherical;
  Result.FData_0 := aR;
  Result.FData_1 := aB;
  Result.FData_2 := aE;
  Result.FData_3 := aTime;
  Result.FData_4 := aVr;
end;

procedure TCoordinates.SetRBE(const aR, aB, aE: Double; aTime: Double);
begin
  Self.FCoordSystem := csSpherical;
  Self.FData_0 := aR;
  Self.FData_1 := aB;
  Self.FData_2 := aE;
  Self.FData_3 := aTime;
end;

class function TCoordinates.CreatePoint(Sourse: TCoordinates): TCoordinates;
begin
  Result := TCoordinates.Create();
  Result.FCoordSystem := Sourse.FCoordSystem;
  Result.FData_0 := Sourse.FData_0;
  Result.FData_1 := Sourse.FData_1;
  Result.FData_2 := Sourse.FData_2;
  Result.FData_3 := Sourse.FData_3;
  Result.FData_4 := Sourse.FData_4;
  Result.Tag := Sourse.Tag;
end;

class function TCoordinates.CreateXYZ(const aX, aY, aZ: Double; aTime: Double): TCoordinates;
begin
  Result := TCoordinates.Create;
  Result.FCoordSystem := csCartesian;
  Result.FData_0 := aX;
  Result.FData_1 := aY;
  Result.FData_2 := aZ;
  Result.FData_3 := aTime;
  Result.FData_4 := 0;
end;

destructor TCoordinates.Destroy;
begin
  inherited;
end;

procedure TCoordinates.SetXYZ(const aX, aY, aZ: Double; aTime: Double);
begin
  Self.FCoordSystem := csCartesian;
  Self.FData_0 := aX;
  Self.FData_1 := aY;
  Self.FData_2 := aZ;
  Self.FData_3 := aTime;
  Self.FData_4 := 0;
end;

procedure TCoordinates.SetPoint(Sourse: TCoordinates);
begin
  Self.FCoordSystem := Sourse.FCoordSystem;
  Self.FData_0 := Sourse.FData_0;
  Self.FData_1 := Sourse.FData_1;
  Self.FData_2 := Sourse.FData_2;
  Self.FData_3 := Sourse.FData_3;
  Self.FData_4 := Sourse.FData_4;
  Self.Tag := Sourse.Tag;
end;

function TCoordinates.GetB: Double;
begin
  case FCoordSystem of
    csCartesian:
      begin
        Result := ArcTan2(FData_1, FData_0);
      end;
    csCylindrical:
      Result := FData_1;
    csSpherical:
      Result := FData_1;
  end;
end;

function TCoordinates.GetD: Double;
begin
  case FCoordSystem of
    csCartesian:
      Result := Hypot(FData_0, FData_1);
    csCylindrical:
      Result := FData_0;
    csSpherical:
      Result := R * Cos(FData_2);
  end;
end;

function TCoordinates.GetE: Double;
var
  LD: Double;
begin
  case FCoordSystem of
    csCartesian:
      begin
        LD := Hypot(FData_0, FData_1);
        Result := ArcTan2(FData_2, LD)
      end;
    csCylindrical:
      begin
        LD := FData_0;
        Result := ArcTan2(FData_2, LD)
      end;
    csSpherical:
      Result := FData_2;
  end;
end;

function TCoordinates.GetR: Double;
var
  LD: Double;
begin
  case FCoordSystem of
    csCartesian:
      begin
        LD := Hypot(FData_0, FData_1);
        Result := Hypot(FData_2, LD);
      end;
    csCylindrical:
      begin
        LD := FData_0;
        Result := Hypot(FData_2, LD);
      end;
    csSpherical:
      Result := FData_0;
  end;
end;

function TCoordinates.GetT: Double;
begin
  Result := FData_3;
end;

function TCoordinates.GetVr: Double;
begin
  Result := FData_4;
end;

procedure TCoordinates.SetVr(const Value: Double);
begin
  FData_4 := Value;
end;

function TCoordinates.GetX: Double;
begin
  case FCoordSystem of
    csCartesian:
      Result := FData_0;
    csCylindrical:
      Result := FData_0 * Cos(FData_1);
    csSpherical:
      Result := FData_0 * Cos(FData_2) * Cos(FData_1);
  else
    begin
      Result := 0;
      Assert(False);
    end;
  end;
end;

function TCoordinates.GetY: Double;
begin
  case FCoordSystem of
    csCartesian:
      Result := FData_1;
    csCylindrical:
      Result := FData_0 * Sin(FData_1);
    csSpherical:
      Result := FData_0 * Cos(FData_2) * Sin(FData_1);
  else
    begin
      Result := 0;
      Assert(False);
    end;
  end;
end;

function TCoordinates.GetZ: Double;
begin
  case FCoordSystem of
    csCartesian:
      Result := FData_2;
    csCylindrical:
      Result := FData_2;
    csSpherical:
      Result := FData_0 * Sin(FData_2);
  else
    begin
      Result := 0;
      Assert(False);
    end;
  end;
end;

procedure TCoordinates.SetB(const Value: Double);
var
  LX, LY, LZ, LD, LValue: Double;
begin
  LValue := {DegToRad}(Value);
  case FCoordSystem of
    csCylindrical:
      FData_1 := LValue;
    csSpherical:
      FData_1 := LValue;
    csCartesian:
      begin
        LX := FData_0;
        LY := FData_1;
        LZ := FData_2;
        if csCylindrical in CoordSystemDefaultSet then
        begin
          FData_0 := Hypot(LX, LY);
          FData_1 := LValue;
          FCoordSystem := csCylindrical;
        end
        else
        begin
          LD := Hypot(LX, LY);
          FData_0 := Hypot(LD, LZ);
          FData_1 := LValue;
          FData_2 := ArcTan2(LZ, LD);
          FCoordSystem := csSpherical;
        end;
      end;
  end;
end;

procedure TCoordinates.SetCoordSystem(const Value: TCoordSystem);
begin
  if FCoordSystem <> Value then
  begin
    case Value of
      csCartesian:
        X := X;
      csCylindrical:
        D := D;
      csSpherical:
        R := R;
    end;
    FCoordSystem := Value;
  end;
end;

procedure TCoordinates.SetD(const Value: Double);
begin
  FData_1 := GetB;
  FData_2 := GetZ;
  FData_0 := Value;
  FCoordSystem := csCylindrical;
end;

procedure TCoordinates.SetE(const Value: Double);
var
  LR, LValue: Double;
begin
  LValue := Value;
  LR := GetR;
  FData_1 := GetB;
  FData_0 := LR;
  FData_2 := LValue;
  FCoordSystem := csSpherical;
end;

procedure TCoordinates.SetR(const Value: Double);
var
  LE: Double;
begin
  LE := GetE;
  FData_1 := GetB;
  FData_2 := LE;
  FData_0 := Value;
  FCoordSystem := csSpherical;
end;

procedure TCoordinates.SetT(const Value: Double);
begin
  FData_3 := Value;
end;

procedure TCoordinates.SetX(const Value: Double);
var
  LY: Double;
begin
  LY := GetY;
  FData_2 := GetZ;
  FData_1 := LY;
  FData_0 := Value;
  FCoordSystem := csCartesian;
end;

procedure TCoordinates.SetY(const Value: Double);
var
  LX: Double;
begin
  LX := GetX;
  FData_2 := GetZ;
  FData_0 := LX;
  FData_1 := Value;
  FCoordSystem := csCartesian;
end;

procedure TCoordinates.SetZ(const Value: Double);
var
  LR, LB, LE: Double;
begin
  case FCoordSystem of
    csCylindrical:
      FData_2 := Value;
    csCartesian:
      FData_2 := Value;
    csSpherical:
      begin
        LR := FData_0;
        LB := FData_1;
        LE := FData_2;
        if csCartesian in CoordSystemDefaultSet then
        begin
          FData_0 := LR * Cos(LE) * Cos(LB);
          FData_1 := LR * Cos(LE) * Sin(LB);
          FData_2 := Value;
          FCoordSystem := csCartesian;
        end
        else
        begin
          FData_0 := LR * Cos(LE);
          FData_2 := Value;
          FCoordSystem := csCylindrical;
        end;
      end;
  end;
end;

initialization
  CoordSystemDefaultSet := [csCartesian, csCylindrical];

end.

