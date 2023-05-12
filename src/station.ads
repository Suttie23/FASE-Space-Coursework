package Station with SPARK_mode
is

   -- Constants
   MINALTITUDE: constant := 820000; -- Station minimum altitude (ft)
   MAXALTITUDE: constant := 920000; -- Station maximum altitude (ft)

   -- Airlock Type
   type Airlock_Door is (Open, Closed);

   -- Module Types
   type Module is (CrewQuarters, CommunicationsArray, ResearchBay, Empty);
   type Module_Array is array (1..3) of Module;

   type CrewMember is (Jebediah, Valentina, Bill);
   type CrewMemberStatus is (Spacewalk, Monitoring, Relaxing);
   type CrewMemberLocation is (TopModule, MiddleModule, BottomModule, EVA);

   type Crew_Record is record
      Name : CrewMember;
      Status : CrewMemberStatus;
      Location : Module;
   end record;

   type Crew_Array is array(1..3) of Crew_Record;

   -- Station Record to hold all Station Variables
   type Station_Record is record
      Door1 : Airlock_Door := Closed;
      Door2 : Airlock_Door := Closed;
      Altitude : Integer range MINALTITUDE..MAXALTITUDE;
      Modules : Module_Array;
      Top_Module_Index : Natural range 1..3;
      Crew : Crew_Array;
   end record;

   S : Station_Record := (Door1 => Closed, Door2 => Closed, Altitude => MINALTITUDE,
                          Modules => (1 => CrewQuarters, 2 => CommunicationsArray, 3 => Empty),
                          Top_Module_Index => 2, Crew =>
                            ((Name => Jebediah, Status => Relaxing, Location => CrewQuarters),
                            (Name => Valentina, Status => Relaxing, Location => CrewQuarters),
                            (Name => Bill, Status => Relaxing, Location => CrewQuarters)));

   function SealedInvariant return Boolean is
     ((S.Door1 = Open and S.Door2 = Closed) or (S.Door1 = Closed and S.Door2 = Open)
      or (S.Door1 = Closed and S.Door2 = Closed));

   function AltitudeInvariant return Boolean is
      (S.Altitude >= MINALTITUDE and S.Altitude <= MAXALTITUDE);

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
     Post => (S.Altitude = New_Height and SealedInvariant and AltitudeInvariant);

   -- Procedure to add a module to the station
   procedure Add_Module(S : in out Station_Record; New_Module : in Module) with
     Pre => SealedInvariant and (S.Top_Module_Index < S.Modules'Last),
     Post => (S.Modules(1) = New_Module) and (S.Top_Module_Index = S'Old.Top_Module_Index + 1) and
     (for all i in 2..S.Modules'Last => S.Modules(i) = S'Old.Modules(i-1)) and SealedInvariant;

   -- Procedure to remove the top module from the stack
   procedure Remove_Top_Module(S : in out Station_Record) with
    Pre => SealedInvariant and S.Top_Module_Index >= 1,
    Post => (S.Top_Module_Index >= 1 and SealedInvariant) or
     (S.Top_Module_Index >= 1 and S.Modules = (2 => Empty, 3 => Empty) and SealedInvariant);

  procedure Attempt_Spacewalk(S : in out Station_Record);


end Station;
