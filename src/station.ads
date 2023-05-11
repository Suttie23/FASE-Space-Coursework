package Station with SPARK_mode
is

   -- Constants
   MINALTITUDE: constant := 820000; -- Station minimum altitude (ft)
   MAXALTITUDE: constant := 920000; -- Station maximum altitude (ft)

   -- Airlock Type
   type Airlock_Door is (Open, Closed);

   -- Module Types
   type Module is (CrewQuarters, DockingHall, ResearchBay, Empty);
   type Module_Array is array (1..3) of Module;

   -- Station Record to hold all Station Variables
   type Station_Record is record
      Door1 : Airlock_Door := Closed;
      Door2 : Airlock_Door := Closed;
      Altitude : Integer range MINALTITUDE..MAXALTITUDE;
      Modules : Module_Array;
      Top_Module_Index : Natural range 0..3 := 0;
   end record;

   S : Station_Record := (Door1 => Closed, Door2 => Closed, Altitude => 820000,
                          Modules => (1 => CrewQuarters, 2 => DockingHall, 3 => Empty),
                         Top_Module_Index => 0);


   function SealedInvariant return Boolean is
     ((S.Door1 = Open and S.Door2 = Closed) or (S.Door1 = Closed and S.Door2 = Open)
     or (S.Door1 = Closed and S.Door2 = Closed));

   -- Procedure to Open an Airlock
   procedure Open_Door (S : in out Station_Record; Airlock_Number : Integer) with
     Pre => SealedInvariant,
     Post => SealedInvariant;

   -- Procedure to Seal the airlock
   procedure Seal_Airlock (S : in out Station_Record) with
     Pre => (S.Door1 = Open and S.Door2 = Closed) or (S.Door2 = Open and S.Door1 = Closed),
     Post => S.Door1 = Closed and S.Door2 = Closed;

   -- Procedure to update height of orbit
   procedure Update_Height(S : in out Station_Record; New_Height : in Integer) with
     Pre => (New_Height >= 820000 and New_Height <= 920000) and SealedInvariant,
     Post => S.Altitude = New_Height and SealedInvariant;

   -- Procedure to add a module to the station
   procedure Add_Module(S : in out Station_Record; New_Module : in Module)
     with Pre => SealedInvariant and (New_Module /= Empty),
     Post => (S.Modules(1) = New_Module) and
        (for all i in 2..S.Modules'Last => S.Modules(i) = S'Old.Modules(i-1)) and SealedInvariant;

   -- Procedure to remove the top module from the stack
   procedure Remove_Top_Module(S : in out Station_Record)
     with Pre => SealedInvariant and (S.Top_Module_Index > 0 or (S.Top_Module_Index = 0 and (S.Modules(2) /= Empty or S.Modules(3) /= Empty))),
          Post => (if S.Top_Module_Index > 0 then S.Top_Module_Index = S'Old.Top_Module_Index - 1 else S.Top_Module_Index = 0)
                   and SealedInvariant;

end Station;
