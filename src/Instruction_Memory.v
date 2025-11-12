module Instruction_Memory(rst,A,RD);

  input rst;
  input [31:0]A;
  output [31:0]RD;

  reg [31:0] mem [1023:0];
  integer fid;
  integer i;
  
  assign RD = (rst == 1'b0) ? {32{1'b0}} : mem[A[31:2]];

  initial begin
    // Initialize memory to NOPs so any address not supplied by the file
    // has a safe default value.
    for (i = 0; i < 1024; i = i + 1) begin
      mem[i] = 32'h00000013; // NOP (addi x0,x0,0)
    end

    // Try to open the memory file. If it exists, use $readmemh to overwrite
    // the initial contents with the file contents.
    fid = $fopen("memfile.hex", "r");
    if (fid) begin
      $fclose(fid);
      $readmemh("memfile.hex", mem);
    end
  end


/*
  initial begin
    //mem[0] = 32'hFFC4A303;
    //mem[1] = 32'h00832383;
    // mem[0] = 32'h0064A423;
    // mem[1] = 32'h00B62423;
    mem[0] = 32'h0062E233;
    // mem[1] = 32'h00B62423;

  end
*/
endmodule