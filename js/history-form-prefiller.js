var PrefillMachine = {

    prefillCorrectly: function() {
        $("#sample_id").val("GU111");
        $("#name").val("John Doe");
        $("#email").val("john@doe.com");

        $("#lat").val("72.47");
        $("#long").val("-56.9");

        $("#zobs").val("0.0");

        $("#be_conc").val("4.26e5");
        $("#al_conc").val("2.37e6");
        $("#c_conc").val("");
        $("#ne_conc").val("");

        $("#be_uncer").val("2.6");
        $("#al_uncer").val("4.0");

        $("#be_prod_spall").val("5.71");
        $("#al_prod_spall").val("38.5");
        $("#c_prod_spall").val("");
        $("#ne_prod_spall").val("");

        $("#be_prod_muons").val("0.206");
        $("#al_prod_muons").val("1.73");
        $("#c_prod_muons").val("");
        $("#ne_prod_muons").val("");

        $("#rock_density").val("2650");

        $("#epsilon_gla_min").val("0.1");
        $("#epsilon_gla_max").val("1000");

        $("#epsilon_int_min").val("0.1");
        $("#epsilon_int_max").val("1000");

        $("#t_degla_min").val("10000");
        $("#t_degla_max").val("12000");

        $("#record_threshold_min").val("3.7");
        $("#record_threshold_max").val("4.3");

    }
}

var PrefillMachine2 = {
    prefillCorrectly2: function() {
        $("#sample_id").val("syn02");
        $("#name").val("John Doe");
        $("#email").val("john@doe.com");

        $("#lat").val("56.08");
        $("#long").val("10.11");

        $("#zobs").val("0.0");

        $("#be_conc").val("1.152e6");
        $("#al_conc").val("4.940e6");
        $("#c_conc").val("1.15e5");
        $("#ne_conc").val("1.2897e7");

        $("#be_uncer").val("2.6");
        $("#al_uncer").val("4.0");
        $("#c_uncer").val("2.0");
        $("#ne_uncer").val("2.0");

        $("#be_prod_spall").val("5.33");
        $("#al_prod_spall").val("31.1");
        $("#c_prod_spall").val("14.6");
        $("#ne_prod_spall").val("20.8");

        $("#be_prod_muons").val("0.106");
        $("#al_prod_muons").val("0.70");
        $("#c_prod_muons").val("2.3");
        $("#ne_prod_muons").val("0.40");

        $("#rock_density").val("2650");
        
        $("#epsilon_gla_min").val("0.1");
        $("#epsilon_gla_max").val("1000");

        $("#epsilon_int_min").val("0.1");
        $("#epsilon_int_max").val("1000");

        $("#t_degla_min").val("10000");
        $("#t_degla_max").val("12000");

        $("#record_threshold_min").val("3.7");
        $("#record_threshold_max").val("4.5");

    }
}

// run the prefiller
PrefillMachine.prefillCorrectly();
PrefillMachine2.prefillCorrectly2();
