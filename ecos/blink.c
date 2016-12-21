#include <cyg/kernel/kapi.h>
#include <cyg/hal/hal_io.h>
#include <cyg/hal/hal_intr.h>

static int flag = 1;  // toggled by interrupt

static int clockwise[] = {
    CYGHWR_HAL_STM32F4DISCOVERY_LED1,
    CYGHWR_HAL_STM32F4DISCOVERY_LED2,
    CYGHWR_HAL_STM32F4DISCOVERY_LED3,
    CYGHWR_HAL_STM32F4DISCOVERY_LED4
};

static int counterclockwise[] = {
    CYGHWR_HAL_STM32F4DISCOVERY_LED4,
    CYGHWR_HAL_STM32F4DISCOVERY_LED3,
    CYGHWR_HAL_STM32F4DISCOVERY_LED2,
    CYGHWR_HAL_STM32F4DISCOVERY_LED1
};

static int* leds;

/*
    3 red
2 orange 4 blue
   1 green
*/


static cyg_uint32 _isr(cyg_vector_t vector, cyg_addrword_t data){

    // mask
    cyg_interrupt_mask(vector);

    // acknowledge
    cyg_interrupt_acknowledge(vector);

    // call DSR
    return CYG_ISR_CALL_DSR;
}

static void _dsr(cyg_vector_t vector, cyg_ucount32 count, cyg_addrword_t data){

    // toggle flag
    for(; count > 0; count--){
        flag ^= 1;
    }
    leds = flag? clockwise: counterclockwise;

    // unmask
    cyg_interrupt_unmask(vector);
}

int main(void) {

    cyg_vector_t  vector = CYGNUM_HAL_INTERRUPT_EXTI0;
    cyg_handle_t  handle;
    cyg_interrupt interrupt;        
   
    // configure
    cyg_interrupt_configure(vector, 0, 1);

    // create
    cyg_interrupt_create(
        vector,
        0,       // Priority
        0,       // Data item passed to ISR & DSR
        _isr,    // ISR
        _dsr,    // DSR
        &handle,
        &interrupt
    );                   

    // attach
    cyg_interrupt_attach(handle);
   
    // unmask
    cyg_interrupt_unmask(vector);    

    // play with leds
    leds = clockwise;
    while(233){
        int i;
        for(i=0; i<4; i++){
            CYGHWR_HAL_STM32_GPIO_OUT(leds[i], 0);
            HAL_DELAY_US(1000 * 100); // 100ms
            CYGHWR_HAL_STM32_GPIO_OUT(leds[i], 1);
        }
    }
}
