// mux2
module mux2 #(parameter WIDTH = 8)
             (d0, d1,
              s, y);
              
    input  [WIDTH-1:0] d0, d1;
    input              s;
    output [WIDTH-1:0] y;          
              
    assign y = ( s == 1'b1 ) ? d1:d0;
    
endmodule

// mux4
module mux4 #(parameter WIDTH = 8)
             (d0, d1, d2, d3,
              s, y);
    
    input  [WIDTH-1:0] d0, d1, d2, d3;
    input  [1:0] s;
    output [WIDTH-1:0] y;
    
    reg [WIDTH-1:0] y_r;
    
    always @( * ) begin
        case ( s )
            2'b00: y_r = d0;
            2'b01: y_r = d1;
            2'b10: y_r = d2;
            2'b11: y_r = d3;
            default: ;
        endcase             
    end // end always
    
    assign y = y_r;
        
endmodule

// mux8
module mux8 #(parameter WIDTH = 8)
             (d0, d1, d2, d3,
              d4, d5, d6, d7,
              s, y);
    
    input  [WIDTH-1:0] d0, d1, d2, d3;
    input  [WIDTH-1:0] d4, d5, d6, d7;
    input  [2:0]       s;
    output [WIDTH-1:0] y;
    
    reg [WIDTH-1:0] y_r;
    
    always @( * ) begin
        case ( s )
            3'd0: y_r = d0;
            3'd1: y_r = d1;
            3'd2: y_r = d2;
            3'd3: y_r = d3;
            3'd4: y_r = d4;
            3'd5: y_r = d5;
            3'd6: y_r = d6;
            3'd7: y_r = d7;
            default: ;
        endcase
    end // end always
    
    assign y = y_r;    
    
endmodule