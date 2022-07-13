`include "hashfunc.v"
module create_bram
	#(
		parameter RAM_WIDTH 		= 32,
		parameter RAM_ADDR_BITS 	= 9,
		//parameter KEY_FILE 		= "keyvalue.txt",
      parameter HASH_1_FILE      = "hash1.txt",
      parameter HASH_2_FILE      = "hash2.txt",
      parameter HASH_1_VALADD_FILE = "",
      parameter HASH_2_VALADD_FILE = "",
      parameter VALUE_FILE = "",
		//parameter KEY_INIT_START_ADDR 	= 0,
		//parameter KEY_INIT_END_ADDR		= 14,
      parameter HASH_1_INIT_START_ADDR 	= 0,
		parameter HASH_1_INIT_END_ADDR		= 4,
      parameter HASH_2_INIT_START_ADDR 	= 0,
		parameter HASH_2_INIT_END_ADDR		= 9,
      parameter HASH_1_VALADD_INIT_START_ADDR 	= 0,
		parameter HASH_1_VALADD_INIT_END_ADDR		= 9,
      parameter HASH_2_VALADD_INIT_START_ADDR 	= 0,
		parameter HASH_2_VALADD_INIT_END_ADDR		= 9,
      parameter VALUE_INIT_START_ADDR = 0,
      parameter VALUE_INIT_END_ADDR = 0
      
	)
	(
	input							clock,
	input							ram_enable,
	input							write_enable,
   input                  [31:0] key,
   input                   [1:0]signal,
   input                   [31:0] transact_value,
   input                   transact_kind,
   output              reg [31:0] value_addr
   output              reg [31:0] updated_value
	);
   


   reg [31:0] hash1;
   reg [31:0] hash2;
   integer i;

   hashfunc aat(.key(key), .hash1(hash1), .hash2(hash2));

   //(* RAM_STYLE="BLOCK" *)
   //reg [RAM_WIDTH-1:0] ram_name_KEY [(2**RAM_ADDR_BITS)-1:0];
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name_HASH_1 [(2**RAM_ADDR_BITS)-1:0];
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name_HASH_2 [(2**RAM_ADDR_BITS)-1:0];
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name_HASH_1_VALADD [(2**RAM_ADDR_BITS)-1:0];
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name_HASH_2_VALADD [(2**RAM_ADDR_BITS)-1:0];
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name_VALUE [(2**RAM_ADDR_BITS)-1:0];



   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   initial begin
      //$readmemh(KEY_FILE, ram_name_KEY, KEY_INIT_START_ADDR, KEY_INIT_END_ADDR);
      $readmemh(HASH_1_FILE, ram_name_HASH_1, HASH_1_INIT_START_ADDR, HASH_1_INIT_END_ADDR);
      $readmemh(HASH_2_FILE, ram_name_HASH_2, HASH_2_INIT_START_ADDR, HASH_2_INIT_END_ADDR);
      $readmemh(HASH_1_VALADD_FILE, ram_name_HASH_1_VALADD, HASH_1_VALADD_INIT_START_ADDR, HASH_1_VALADD_INIT_END_ADDR);
      $readmemh(HASH_2_VALADD_FILE, ram_name_HASH_2_VALADD, HASH_2_VALADD_INIT_START_ADDR, HASH_2_VALADD_INIT_END_ADDR);
      $readmemh(VALUE_FILE, ram_name_VALUE, VALUE_INIT_START_ADDR, VALUE_INIT_END_ADDR);
   end
    
   always @(posedge clock) begin
      #15;
      /*for (i =0 ;i<15 ;i=i+1 ) begin
         $display("KEY %d ", ram_name_KEY[i]);
         
      end
      for (i =0 ;i<5 ;i=i+1 ) begin
         $display("HASH1 %d ", ram_name_HASH_1[i]);
      end
      for (i =0 ;i<10 ;i=i+1 ) begin
         $display("HASH2 %d ", ram_name_HASH_2[i]);
      end

      */

      if (signal==0) begin
         //search
         if(ram_name_HASH_1[hash1] == key) begin
            value_addr = ram_name_HASH_1_VALADD[hash1];
            updated_value = ram_name_VALUE[value_addr];
         end
         else begin
            if(ram_name_HASH_2[hash2] == key) begin
               value_addr = ram_name_HASH_2_VALADD[hash2];
               updated_value = ram_name_VALUE[value_addr];
            end
         end
      end else begin
        if (signal==1) begin
         //insert

         end else begin
          //transact
            if(transact_kind == 1) begin
               if(ram_name_HASH_1[hash1] == key) begin
                  value_addr = ram_name_HASH_1_VALADD[hash1];
                  updated_value = ram_name_VALUE[value_addr] + transact_value;
                  ram_name_VALUE[value_addr] = updated_value;                  
               end
               else begin
                  if(ram_name_HASH_2[hash2] == key) begin
                     value_addr = ram_name_HASH_2_VALADD[hash2];
                     updated_value = ram_name_VALUE[value_addr] + transact_value;
                     ram_name_VALUE[value_addr] = updated_value;
                  end
               end
            end

            if(transact_kind == 0) begin
               if(ram_name_HASH_1[hash1] == key) begin
                  value_addr = ram_name_HASH_1_VALADD[hash1];
                  updated_value = ram_name_VALUE[value_addr] - transact_value;
                  ram_name_VALUE[value_addr] = updated_value;                  
               end
               else begin
                  if(ram_name_HASH_2[hash2] == key) begin
                     value_addr = ram_name_HASH_2_VALADD[hash2];
                     updated_value = ram_name_VALUE[value_addr] - transact_value;
                     ram_name_VALUE[value_addr] = updated_value;
                  end
               end
            end
         end     
      end




   

   end
      
      

endmodule
						