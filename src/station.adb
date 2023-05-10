with Ada.Text_IO; use Ada.Text_IO;

package body Station with SPARK_mode
is

procedure Open_Door (S : in out Station_Record; Airlock_Number : Integer) is
   begin
      if Airlock_Number = 1 then
         S.Door1 := Open;
         S.Door2 := Closed;
      elsif Airlock_Number = 2 then
         S.Door2 := Open;
         S.Door1 := Closed;
      end if;
   end Open_Door;

   procedure Seal_Airlock (S : in out Station_Record) is
   begin
         if S.Door1 = Open then
         S.Door1 := Closed;
      elsif S.Door2 = Open then
         S.Door2 := Closed;
      end if;
   end Seal_Airlock;


end Station;
