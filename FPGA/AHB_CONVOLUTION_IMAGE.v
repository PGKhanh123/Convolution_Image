 module AHB_CONVOLUTION_IMAGE(
    // AHB signals
    input  wire        HCLK,
    input  wire        HRESETn,
    input  wire [31:0] HADDR,
    input  wire [1:0]  HTRANS,
    input  wire [31:0] HWDATA,
    input  wire        HWRITE,
    input  wire        HREADY,
    input  wire        HSEL,

    output wire        HREADYOUT,
    output reg  [31:0] HRDATA,

    // memory interface (from original module)
    output wire        mem_w_en,
    output wire        mem_r_en,
    output wire [17:0] mem_addr,
    output wire [31:0] mem_write_data,
    input  wire [31:0] mem_read_data
);

    //--------------------------------------------------------------------
    // AHB register stage
    //--------------------------------------------------------------------
    reg [1:0]  last_HTRANS;
    reg [31:0] last_HADDR;
    reg        last_HWRITE;
    reg        last_HSEL;

    always @(posedge HCLK) begin
        if(HREADY) begin
            last_HTRANS <= HTRANS;
            last_HWRITE <= HWRITE;
            last_HSEL   <= HSEL;
            last_HADDR  <= HADDR;
        end
    end

    assign HREADYOUT = 1'b1;   // module luôn sẵn sàng (không stall)

    //--------------------------------------------------------------------
    // Internal registers for convolution_image
    //--------------------------------------------------------------------
    reg start_reg;
    wire done;

    reg [7:0] N_reg, K_reg;
    reg [17:0] base_in_reg, base_k_reg, base_out_reg;

    //--------------------------------------------------------------------
    // AHB Write decode
    //--------------------------------------------------------------------
    wire write_en = last_HTRANS[1] & last_HWRITE & last_HSEL;

    always @(posedge HCLK or negedge HRESETn) begin
        if(!HRESETn) begin
            start_reg <= 0;
            N_reg <= 0; K_reg <= 0;
            base_in_reg <= 0;
            base_k_reg  <= 0;
            base_out_reg <= 0;
        end else if(write_en) begin
            case(last_HADDR[7:0])
                8'h00: start_reg    <= HWDATA[0];
                8'h08: N_reg        <= HWDATA[7:0];
                8'h0C: K_reg        <= HWDATA[7:0];
                8'h10: base_in_reg  <= HWDATA[17:0];
                8'h14: base_k_reg   <= HWDATA[17:0];
                8'h18: base_out_reg <= HWDATA[17:0];
            endcase
        end
    end

    //--------------------------------------------------------------------
    // AHB Read decode
    //--------------------------------------------------------------------
    always @(*) begin
        case(last_HADDR[7:0])
            8'h00: HRDATA = {31'b0, start_reg};
            8'h04: HRDATA = {31'b0, done};
            8'h08: HRDATA = {24'h0, N_reg};
            8'h0C: HRDATA = {24'h0, K_reg};
            8'h10: HRDATA = {14'h0, base_in_reg};
            8'h14: HRDATA = {14'h0, base_k_reg};
            8'h18: HRDATA = {14'h0, base_out_reg};
            default: HRDATA = 32'h0;
        endcase
    end


    //--------------------------------------------------------------------
    // Instantiate original convolution unit
    //--------------------------------------------------------------------
    convolution_image core (
        .start(start_reg),
        .clk(HCLK),
        .rst(~HRESETn),
        .done(done),

        .N(N_reg),
        .K(K_reg),
        .base_in(base_in_reg),
        .base_k(base_k_reg),
        .base_out(base_out_reg),

        .mem_w_en(mem_w_en),
        .mem_r_en(mem_r_en),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_read_data(mem_read_data)
    );

endmodule
