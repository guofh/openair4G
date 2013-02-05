// Matthias Ihmig, based on code from Maxime Guillaud - created 28.01.2013
// see http://www.gnu.org/software/octave/doc/interpreter/Dynamically-Linked-Functions.html#Dynamically-Linked-Functions
// and http://wiki.octave.org/wiki.pl?CodaTutorial
// and http://octave.sourceforge.net/coda/c58.html
// compilation: see Makefile

#include <octave/oct.h>

#include "pcie_interface.h"

extern "C" {
#include "openair0_lib.h"
}

#define FCNNAME "oarf_config_exmimo"

#define TRACE 1

static bool any_bad_argument(const octave_value_list &args)
{
    octave_value v,w;
    int i;

    if (args.length()!=12)
    {
        error(FCNNAME);
        if (args.length()==11)
            error("Wrong number of parameters! Did you add the card number?");
        error("syntax: oarf_config_exmimo(card,freqrx,freq_tx,tdd_config,dual_tx,rxgain,txgain,eNB_flag,rf_mode,rx_dc,rf_local,rf_vcolocal)");
        return true;
    }

    v=args(1);
    for (i=0;i<v.columns();i++) {
        if ((real(v.row_vector_value()(i)) < 0.0) || 
            (floor(real(v.row_vector_value()(i))) != real(v.row_vector_value()(i))) || 
            (real(v.row_vector_value()(i)) > 3.9e9))
        {
            error(FCNNAME);
            error("rx freqband %d must be 0-3.9e9",i);
            return true;
        }
    }

    v=args(2);
    for (i=0;i<v.columns();i++) {
        if ((real(v.row_vector_value()(i)) < 0.0) || 
            (floor(real(v.row_vector_value()(i))) != real(v.row_vector_value()(i))) || 
            (real(v.row_vector_value()(i)) > 3.9e9))
        {
            error(FCNNAME);
            error("tx freqband %d must be 0-3.9e9",i);
            return true;
        }
    }

    if ((!args(3).is_real_scalar()))
    {
        error(FCNNAME);
        error("tdd_config must be an integer.");
        return true;
    }

    if ((!args(4).is_real_scalar()))
    {
        error(FCNNAME);
        error("dual_tx must be 0 or 1.");
        return true;
    }

    v=args(5);
    if (v.columns() == 4)
    {
        for (i=0;i<v.columns();i++)
        {
            if ((real(args(5).row_vector_value()(i))<0.0) || (real(args(5).row_vector_value()(i))>50.0))
            {
                error(FCNNAME);
                error("rx gain must be between 0 and 50. (got %f).",args(5).row_vector_value()(i));
                return true;
            }
        }
    }
    else {
        error(FCNNAME);
        error("number of columns for rxgain must be 4 (got %d)\n",v.columns());
    }

    v=args(6);
    if (v.columns() == 4)
    {
        for (i=0;i<v.columns();i++)
        {
            if ((real(args(6).row_vector_value()(i))<0.0) || (real(args(6).row_vector_value()(i))>50.0))
            {
                error(FCNNAME);
                error("tx gain must be between 0 and 50. (got %f).",args(6).row_vector_value()(i));
                return true;
            }
        }
    }
    else {
        error(FCNNAME);
        error("number of columns for txgain must be 4 (got %d)\n",v.columns());
    }


    if ((!args(7).is_real_scalar()) || (args(7).scalar_value()<0.0) || (args(7).scalar_value()>1)) {
        error(FCNNAME);
        error("eNB_flag must be between 0 and 1 (got %f).",args(7).scalar_value());
        return true;
    }

    v = args(8);
    if (v.columns() == 4)
    {
        for (i=0;i<v.columns();i++)
        {
            if ((v.row_vector_value()(i)<0.0) || (v.row_vector_value()(i)>(double)((uint32_t)(1<<25)))) {
                error(FCNNAME);
                error("rf_mode %d must be between 0 and 2^25 (got %f).",i,v.row_vector_value()(i));
                return true;
            }
        }
    }
    else {
        error(FCNNAME);
        error("number of columns for rf_mode must be 4\n");
    }

    v = args(9);
    if (v.columns() == 4)
    {
        for (i=0;i<v.columns();i++)
        {
            if ((v.row_vector_value()(i)<0.0) || (v.row_vector_value()(i)>(double)((uint32_t)(1<<16)))) {
                error(FCNNAME);
                error("rx_dc %d must be between 0 and 2^16 (got %f).",i,v.row_vector_value()(i));
                return true;
            }
        }
    }
    else {
        error(FCNNAME);
        error("number of columns for rf_mode must be 4\n");
    }  

    v = args(10);
    if (v.columns() == 4)
    {
        for (i=0;i<v.columns();i++)
        {
            if ((v.row_vector_value()(i)<0.0) || (v.row_vector_value()(i)>(double)((uint32_t)(1<<24)))) {
                error(FCNNAME);
                error("rf_local %d must be between 0 and 2^24 (got %f).",i,v.row_vector_value()(i));
                return true;
            }
        }
    }
    else {
        error(FCNNAME);
        error("number of columns for rf_local must be 4\n");
    }

    v = args(11);
    if (v.columns() == 4)
    {
        for (i=0;i<v.columns();i++)
        {
            if ((v.row_vector_value()(i)<0.0) || (v.row_vector_value()(i)>(double)((uint32_t)(1<<12)))) {
                error(FCNNAME);
                error("rf_vcocal %d must be between 0 and 2^12 (got %f).",i,v.row_vector_value()(i));
                return true;
            }
        }
    }
    else {
        error(FCNNAME);
        error("number of columns for rf_vcocal must be 4\n");
    }
    
    if ( !args(0).is_real_scalar() )
    {
        error(FCNNAME);
        error("card_id must be scalar (count starting from 0).\nUse card_id = -1 to configure all cards");
        return true;
    }

    return false;
}



DEFUN_DLD (oarf_config_exmimo, args, nargout,"configure the openair interface - returns 0 if successful")
{
    int ret;
    int ant;
    int a,b;
    if (any_bad_argument(args))
        return octave_value_list();

    int card             = args(0).int_value();
    RowVector freqrx     = args(1).row_vector_value();
    RowVector freqtx     = args(2).row_vector_value();
    const int tdd_config = args(3).int_value();
    const int dual_tx    = args(4).int_value();
    RowVector rxgain     = args(5).row_vector_value();
    RowVector txgain     = args(6).row_vector_value();
    const int eNB_flag   = args(7).int_value();
    RowVector rf_mode    = args(8).row_vector_value();
    RowVector rf_dc      = args(9).row_vector_value();
    RowVector rf_local   = args(10).row_vector_value();
    RowVector rf_vcocal  = args(11).row_vector_value();
    
    exmimo_config_t *p_exmimo_config;
    exmimo_id_t *p_exmimo_id;

    octave_value returnvalue;

    ret = openair0_open();
    if ( ret != 0 )
    {
        error(FCNNAME);
        if (ret == -1)
            error("Error opening /dev/openair0");
        if (ret == -2)
            error("Error mapping bigshm");
        if (ret == -3)
            error("Error mapping RX or TX buffer");
        return octave_value(ret);
    }

    if (card <-1 || card >= openair0_num_detected_cards)
        error("Invalid card number!");

    if (card == -1) {
        a = 0;
        b = openair0_num_detected_cards;
    } else {
        a = card;
        b = card+1;
    }
    
    for (card = a; card < b; card++)
    {
        p_exmimo_config = openair0_exmimo_pci[card].exmimo_config_ptr;
        p_exmimo_id     = openair0_exmimo_pci[card].exmimo_id_ptr;
            
        p_exmimo_config->framing.eNB_flag   = eNB_flag;
        p_exmimo_config->framing.tdd_config = tdd_config;
        
        for (ant=0; ant<4; ant++)
        {
            p_exmimo_config->rf.rf_freq_rx[ant] = freqrx(ant);
            p_exmimo_config->rf.rf_freq_tx[ant] = freqtx(ant);
            p_exmimo_config->rf.rx_gain[ant][0] = (uint32_t) rxgain(ant);
            p_exmimo_config->rf.tx_gain[ant][0] = (uint32_t) txgain(ant);
            p_exmimo_config->rf.rf_mode[ant] = rf_mode(ant);
            
            p_exmimo_config->rf.rf_local[ant] = rf_local(ant);
            p_exmimo_config->rf.rf_rxdc[ant] = rf_dc(ant);
            p_exmimo_config->rf.rf_vcocal[ant] = rf_vcocal(ant);
        }

        returnvalue = openair0_dump_config( card );
        
        printf("Card %d: ExpressMIMO %d, SW Rev 0x%d\n", card, p_exmimo_id->board_exmimoversion, p_exmimo_id->board_swrev);
    }
    
    openair0_close();

    return octave_value(returnvalue);
}

