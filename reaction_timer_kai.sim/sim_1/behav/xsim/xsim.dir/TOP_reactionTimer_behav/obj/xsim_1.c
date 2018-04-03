/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_302(char*, char *);
extern void execute_303(char*, char *);
extern void execute_304(char*, char *);
extern void execute_305(char*, char *);
extern void execute_306(char*, char *);
extern void execute_307(char*, char *);
extern void execute_308(char*, char *);
extern void execute_309(char*, char *);
extern void execute_310(char*, char *);
extern void execute_311(char*, char *);
extern void execute_312(char*, char *);
extern void execute_313(char*, char *);
extern void execute_314(char*, char *);
extern void execute_315(char*, char *);
extern void execute_316(char*, char *);
extern void execute_317(char*, char *);
extern void execute_3(char*, char *);
extern void execute_4(char*, char *);
extern void execute_6(char*, char *);
extern void execute_7(char*, char *);
extern void execute_9(char*, char *);
extern void execute_10(char*, char *);
extern void execute_179(char*, char *);
extern void execute_180(char*, char *);
extern void execute_15(char*, char *);
extern void execute_16(char*, char *);
extern void execute_183(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_27(char*, char *);
extern void execute_28(char*, char *);
extern void execute_169(char*, char *);
extern void execute_170(char*, char *);
extern void execute_287(char*, char *);
extern void execute_288(char*, char *);
extern void execute_289(char*, char *);
extern void execute_290(char*, char *);
extern void execute_291(char*, char *);
extern void execute_292(char*, char *);
extern void execute_293(char*, char *);
extern void execute_294(char*, char *);
extern void execute_295(char*, char *);
extern void execute_296(char*, char *);
extern void execute_297(char*, char *);
extern void execute_298(char*, char *);
extern void execute_299(char*, char *);
extern void execute_300(char*, char *);
extern void execute_301(char*, char *);
extern void execute_46(char*, char *);
extern void execute_57(char*, char *);
extern void execute_194(char*, char *);
extern void execute_197(char*, char *);
extern void execute_198(char*, char *);
extern void execute_199(char*, char *);
extern void execute_200(char*, char *);
extern void execute_201(char*, char *);
extern void execute_202(char*, char *);
extern void execute_203(char*, char *);
extern void execute_204(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_207(char*, char *);
extern void execute_36(char*, char *);
extern void execute_37(char*, char *);
extern void execute_48(char*, char *);
extern void execute_49(char*, char *);
extern void execute_51(char*, char *);
extern void execute_55(char*, char *);
extern void execute_56(char*, char *);
extern void execute_84(char*, char *);
extern void execute_85(char*, char *);
extern void execute_218(char*, char *);
extern void execute_219(char*, char *);
extern void execute_220(char*, char *);
extern void execute_221(char*, char *);
extern void execute_222(char*, char *);
extern void execute_223(char*, char *);
extern void execute_224(char*, char *);
extern void execute_225(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_228(char*, char *);
extern void execute_66(char*, char *);
extern void execute_67(char*, char *);
extern void execute_212(char*, char *);
extern void execute_71(char*, char *);
extern void execute_72(char*, char *);
extern void execute_73(char*, char *);
extern void execute_81(char*, char *);
extern void execute_82(char*, char *);
extern void execute_83(char*, char *);
extern void execute_215(char*, char *);
extern void execute_216(char*, char *);
extern void execute_217(char*, char *);
extern void execute_76(char*, char *);
extern void execute_77(char*, char *);
extern void execute_121(char*, char *);
extern void execute_122(char*, char *);
extern void execute_248(char*, char *);
extern void execute_249(char*, char *);
extern void execute_250(char*, char *);
extern void execute_251(char*, char *);
extern void execute_252(char*, char *);
extern void execute_253(char*, char *);
extern void execute_254(char*, char *);
extern void execute_255(char*, char *);
extern void execute_94(char*, char *);
extern void execute_95(char*, char *);
extern void execute_103(char*, char *);
extern void execute_104(char*, char *);
extern void execute_237(char*, char *);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_244(char*, char *);
extern void execute_245(char*, char *);
extern void execute_246(char*, char *);
extern void execute_247(char*, char *);
extern void execute_117(char*, char *);
extern void execute_118(char*, char *);
extern void execute_162(char*, char *);
extern void execute_163(char*, char *);
extern void execute_258(char*, char *);
extern void execute_268(char*, char *);
extern void execute_269(char*, char *);
extern void execute_270(char*, char *);
extern void execute_271(char*, char *);
extern void execute_272(char*, char *);
extern void execute_273(char*, char *);
extern void execute_274(char*, char *);
extern void execute_275(char*, char *);
extern void execute_276(char*, char *);
extern void execute_277(char*, char *);
extern void execute_278(char*, char *);
extern void execute_279(char*, char *);
extern void execute_280(char*, char *);
extern void execute_281(char*, char *);
extern void execute_282(char*, char *);
extern void execute_283(char*, char *);
extern void execute_284(char*, char *);
extern void execute_143(char*, char *);
extern void execute_144(char*, char *);
extern void execute_261(char*, char *);
extern void execute_172(char*, char *);
extern void execute_173(char*, char *);
extern void execute_174(char*, char *);
extern void execute_176(char*, char *);
extern void execute_177(char*, char *);
extern void execute_178(char*, char *);
extern void execute_318(char*, char *);
extern void execute_319(char*, char *);
extern void execute_320(char*, char *);
extern void execute_321(char*, char *);
extern void execute_322(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_213(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_341(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[155] = {(funcp)execute_302, (funcp)execute_303, (funcp)execute_304, (funcp)execute_305, (funcp)execute_306, (funcp)execute_307, (funcp)execute_308, (funcp)execute_309, (funcp)execute_310, (funcp)execute_311, (funcp)execute_312, (funcp)execute_313, (funcp)execute_314, (funcp)execute_315, (funcp)execute_316, (funcp)execute_317, (funcp)execute_3, (funcp)execute_4, (funcp)execute_6, (funcp)execute_7, (funcp)execute_9, (funcp)execute_10, (funcp)execute_179, (funcp)execute_180, (funcp)execute_15, (funcp)execute_16, (funcp)execute_183, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_27, (funcp)execute_28, (funcp)execute_169, (funcp)execute_170, (funcp)execute_287, (funcp)execute_288, (funcp)execute_289, (funcp)execute_290, (funcp)execute_291, (funcp)execute_292, (funcp)execute_293, (funcp)execute_294, (funcp)execute_295, (funcp)execute_296, (funcp)execute_297, (funcp)execute_298, (funcp)execute_299, (funcp)execute_300, (funcp)execute_301, (funcp)execute_46, (funcp)execute_57, (funcp)execute_194, (funcp)execute_197, (funcp)execute_198, (funcp)execute_199, (funcp)execute_200, (funcp)execute_201, (funcp)execute_202, (funcp)execute_203, (funcp)execute_204, (funcp)execute_205, (funcp)execute_206, (funcp)execute_207, (funcp)execute_36, (funcp)execute_37, (funcp)execute_48, (funcp)execute_49, (funcp)execute_51, (funcp)execute_55, (funcp)execute_56, (funcp)execute_84, (funcp)execute_85, (funcp)execute_218, (funcp)execute_219, (funcp)execute_220, (funcp)execute_221, (funcp)execute_222, (funcp)execute_223, (funcp)execute_224, (funcp)execute_225, (funcp)execute_226, (funcp)execute_227, (funcp)execute_228, (funcp)execute_66, (funcp)execute_67, (funcp)execute_212, (funcp)execute_71, (funcp)execute_72, (funcp)execute_73, (funcp)execute_81, (funcp)execute_82, (funcp)execute_83, (funcp)execute_215, (funcp)execute_216, (funcp)execute_217, (funcp)execute_76, (funcp)execute_77, (funcp)execute_121, (funcp)execute_122, (funcp)execute_248, (funcp)execute_249, (funcp)execute_250, (funcp)execute_251, (funcp)execute_252, (funcp)execute_253, (funcp)execute_254, (funcp)execute_255, (funcp)execute_94, (funcp)execute_95, (funcp)execute_103, (funcp)execute_104, (funcp)execute_237, (funcp)execute_119, (funcp)execute_120, (funcp)execute_244, (funcp)execute_245, (funcp)execute_246, (funcp)execute_247, (funcp)execute_117, (funcp)execute_118, (funcp)execute_162, (funcp)execute_163, (funcp)execute_258, (funcp)execute_268, (funcp)execute_269, (funcp)execute_270, (funcp)execute_271, (funcp)execute_272, (funcp)execute_273, (funcp)execute_274, (funcp)execute_275, (funcp)execute_276, (funcp)execute_277, (funcp)execute_278, (funcp)execute_279, (funcp)execute_280, (funcp)execute_281, (funcp)execute_282, (funcp)execute_283, (funcp)execute_284, (funcp)execute_143, (funcp)execute_144, (funcp)execute_261, (funcp)execute_172, (funcp)execute_173, (funcp)execute_174, (funcp)execute_176, (funcp)execute_177, (funcp)execute_178, (funcp)execute_318, (funcp)execute_319, (funcp)execute_320, (funcp)execute_321, (funcp)execute_322, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_213, (funcp)transaction_341};
const int NumRelocateId= 155;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/TOP_reactionTimer_behav/xsim.reloc",  (void **)funcTab, 155);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/TOP_reactionTimer_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/TOP_reactionTimer_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/TOP_reactionTimer_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/TOP_reactionTimer_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/TOP_reactionTimer_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
