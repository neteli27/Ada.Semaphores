--Hryshko Nataliia Serhiivna
--Lab1 Ada.Semaphores
--20.02.2018
--ER ICIT CS-322A
--Task a=max(MB*MC + q*ME);

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control;

procedure Lab1 is
   N: integer:= 100;
   p:integer:=4;
   H:integer:=N/p;

   -- types
   type Vector is array(1.. N) of integer;
   type Matrix is array(1.. N) of Vector;

   --variables
   MB, MC, ME, MA: Matrix;
   a:integer:=0;
   q:integer;

   --semaphores
   Sa, Sc, S21, S31, S41, S11, S32, S42, S13, S14, S12, S22, S33, S15:Suspension_Object;

   --threads

   procedure Start_Task is

     task T1;
      task body T1 is
         a1:integer:=0;
         q1:integer;
         MC1:Matrix;
      begin
         Put_Line("T1 is started");
         --data input
         q:=5;

         --signals
         Set_True(S21);
         Set_True(S31);
         Set_True(S41);
         --wait
         Suspend_Until_True(S12);
         Suspend_Until_True(S11);

         --copy q, MC
         Suspend_Until_True(Sc);
         q1:=q; --Critical region
         for i in 1..N loop
            for j in 1..N loop
               MC1(i)(j):= MC(i)(j);
            end loop;
         end loop;
         Set_True(Sc);
         --counting
         for n in 1..H loop
            for i in 1..N loop
               MA(n)(i) := 0;
               for j in 1..N loop
                  MA(n)(i):=MA(n)(i)+MB(n)(j)*MC1(j)(i);
               end loop;
               MA(n)(i):=MA(n)(i) + q*ME(n)(i);
               if a1<MA(n)(i) then
                  a1:= MA(n)(i);
               end if;
            end loop;
         end loop;
         Suspend_Until_True(Sa);
         if a<a1 then
            a:=a1;
         end if;
         Set_True(Sa);
         --wait finishing of work another tasks
         Suspend_Until_True(S13);
         Suspend_Until_True(S14);
         Suspend_Until_True(S15);
         --output data
         Put_Line("Maximal value a = " & integer'image(a));
         --put("Maximal value a = ");
         --put(a);
         Put_Line("T1 is finished");

      end T1;

      task T2;
      task body T2 is
         a2:integer:=0;
         q2:integer;
         MC2:Matrix;
      begin
         Put_Line("T2 is started");
         --input MB
         for i in 1..N loop
            for j in 1..N loop
               MB(i)(j) := 1;
            end loop;
         end loop;
         --signals
         Set_True(S11);
         Set_True(S32);
         Set_True(S42);
         --waiting
         Suspend_Until_True(S21);
         Suspend_Until_True(S22);
         --copy q, MC
         Suspend_Until_True(Sc);
         q2:=q;
         for i in 1..N loop
            for j in 1..N loop
               MC2(i)(j):= MC(i)(j);
            end loop;
         end loop;
        Set_True(Sc);
         --counting
         for n in H+1..2*H loop
            for i in 1..N loop
               MA(n)(i) := 0;
               for j in 1..N loop
                  MA(n)(i):=MA(n)(i)+MB(n)(j)*MC2(j)(i);
               end loop;
               MA(n)(i):=MA(n)(i) + q*ME(n)(i);
               if a2<MA(n)(i) then
                  a2:= MA(n)(i);
               end if;
            end loop;
         end loop;
         Suspend_Until_True(Sa);
         if a<a2 then
            a:=a2;
         end if;
         Set_True(Sa);
         --signal
         Set_True(S13);
         Put_Line("T2 is finished");
      end T2;

      task T3;
      task body T3 is
         a3:integer:=0;
         q3:integer;
         MC3:Matrix;
      begin
         Put_Line("T3 is started");
         --waiting
         Suspend_Until_True(S31);
         Suspend_Until_True(S32);
         Suspend_Until_True(S33);
         --copy q, MC
         Suspend_Until_True(Sc);
         q3:=q;
         for i in 1..N loop
            for j in 1..N loop
               MC3(i)(j):= MC(i)(j);
            end loop;
         end loop;
         Set_True(Sc);
         --counting
         for n in 2*H+1..3*H loop
            for i in 1..N loop
               MA(n)(i) := 0;
               for j in 1..N loop
                  MA(n)(i):=MA(n)(i)+MB(n)(j)*MC3(j)(i);
               end loop;
               MA(n)(i):=MA(n)(i) + q*ME(n)(i);
               if a3<MA(n)(i) then
                  a3:= MA(n)(i);
               end if;
            end loop;
         end loop;
         Suspend_Until_True(Sa);
         if a<a3 then
            a:=a3;
         end if;
         Set_True(Sa);
         --signal about finishing of the work
         Set_True(S14);
         Put_Line("T3 is finished");
      end T3;

      task T4;
      task body T4 is
         a4:integer:=0;
         q4:integer;
         MC4:Matrix;
      begin
         Put_Line("T4 is started");
         --input MC
         for i in 1..N loop
            for j in 1..N loop
               MC(i)(j) := 1;
            end loop;
         end loop;
         --input ME
         for i in 1..N loop
            for j in 1..N loop
               ME(i)(j) := 1;
            end loop;
         end loop;
         --signals
         Set_True(S12);
         Set_True(S22);
         Set_True(S33);
         --waiting
         Suspend_Until_True(S41);
         Suspend_Until_True(S42);

         --copy q, MC
         Suspend_Until_True(Sc);
         q4:=q;
         for i in 1..N loop
            for j in 1..N loop
               MC4(i)(j):= MC(i)(j);
            end loop;
         end loop;
         Set_True(Sc);
         --counting
         for n in 3*H+1..4*H loop
            for i in 1..N loop
               MA(n)(i) := 0;
               for j in 1..N loop
                  MA(n)(i):=MA(n)(i)+MB(n)(j)*MC4(j)(i);
               end loop;
               MA(n)(i):=MA(n)(i) + q*ME(n)(i);
               if a4<MA(n)(i) then
                  a4:= MA(n)(i);
               end if;
            end loop;
         end loop;
         Suspend_Until_True(Sa);
         if a<a4 then
            a:=a4;
         end if;
         Set_True(Sa);
         --signal
         Set_True(S15);
         Put_Line("T4 is finished");
      end T4;
   begin
     null;
   end Start_Task;
begin
   Set_True(Sa);
   Set_True(Sq);
   Set_True(Smc);
   Start_Task;
   null;
end Lab1;
