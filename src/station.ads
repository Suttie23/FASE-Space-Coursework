package Station with SPARK_mode
is

   -- Airlock Type
   type Airlock_Door is (Open, Closed);

   -- Constants
   MINALTITUDE: constant := 820000; -- Station minimum altitude (ft)
   MAXALTITUDE: constant := 920000; -- Station maximum altitude (ft)

   -- Station Record to hold all Station Variables
   type Station_Record is record
      Door1 : Airlock_Door := Closed;
      Door2 : Airlock_Door := Closed;
      Altitude : Integer range MINALTITUDE..MAXALTITUDE;
   end record;

   S : Station_Record;

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

end Station;
