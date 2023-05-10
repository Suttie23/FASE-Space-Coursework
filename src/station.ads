package Station with SPARK_mode
is

   -- Airlock Type
   type Airlock_Door is (Open, Closed);

   -- Station Record to hold all Station Variables
   type Station_Record is record
      Door1 : Airlock_Door := Closed;
      Door2 : Airlock_Door := Closed;
   end record;

   S : Station_Record := (Door1 => Closed, Door2 => Closed);

   -- Procedure to Open an Airlock
   procedure Open_Door (S : in out Station_Record; Airlock_Number : Integer) with
     Pre => 1 <= Airlock_Number and Airlock_Number <= 2,
     Post => (Airlock_Number = 1 and S.Door1 = Open and S.Door2 = Closed) or
     (Airlock_Number = 2 and S.Door2 = Open and S.Door1 = Closed);

   -- Procedure to Seal the airlock
   procedure Seal_Airlock (S : in out Station_Record) with
     Pre => (S.Door1 = Open and S.Door2 = Closed) or (S.Door2 = Open and S.Door1 = Closed),
     Post => S.Door1 = Closed and S.Door2 = Closed;

end Station;
