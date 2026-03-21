unit Infraestructure.BaseClass;

interface

uses
  System.Classes;

type
  TInfraestructureBaseClass = class(TPersistent)
  public
    procedure Assign(Source: TPersistent); override;
  end;

implementation

uses
  System.Rtti, System.TypInfo;

{ TInfraestructureBaseClass }

procedure TInfraestructureBaseClass.Assign(Source: TPersistent);
var
  Ctx: TRttiContext;
  SourceType, TargetType: TRttiType;
  SourceProp, TargetProp: TRttiProperty;
  Value: TValue;
begin
  Ctx := TRttiContext.Create;
  try
    SourceType := Ctx.GetType(Source.ClassType);
    TargetType := Ctx.GetType(Self.ClassType);

    for SourceProp in SourceType.GetProperties do
    begin
      // Apenas propriedades legíveis
      if not SourceProp.IsReadable then
        Continue;

      // Busca propriedade equivalente no destino
      TargetProp := TargetType.GetProperty(SourceProp.Name);

      if (TargetProp = nil) then
        Continue;

      // Precisa ser gravável
      if not TargetProp.IsWritable then
        Continue;

      // Tipos compatíveis
      if SourceProp.PropertyType.Handle <> TargetProp.PropertyType.Handle then
        Continue;

      try
        Value := SourceProp.GetValue(Source);
        TargetProp.SetValue(Self, Value);
      except
        // Evita quebrar assign por uma propriedade problemática
      end;
    end;
  finally
    Ctx.Free;
  end;
end;

end.
